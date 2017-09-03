//
//  zfp.swift
//
//  Created by William Shipley on 8/31/17.
//  Copyright © 2017 Delicious Monster. All rights reserved.
//

public extension Sequence where Iterator.Element : FloatingPoint { // MARK: compressing

    // Note: you MUST decompress with the same accuracy, OR write a header now and use it when decompressing.
    public func compress1D(accuracy: Double, header: Bool = true) -> [UInt8]? {
        let values = Array(self)
        return ZFPSession.compress1D(values, setParameters: { zfp_stream_set_accuracy($0, accuracy) }, header: header)
    }
    public func compress1D(precision: Int, header: Bool = true) -> [UInt8]? {
        let values = Array(self)
        return ZFPSession.compress1D(values, setParameters: { zfp_stream_set_precision($0, uint(precision)) }, header: header)
    }

    public func compress2D(x: Int, y: Int, accuracy: Double, header: Bool = true) -> [UInt8]? {
        let values = Array(self)
        return ZFPSession.compress2D(values, x: x, y: y, setParameters: { zfp_stream_set_accuracy($0, accuracy) }, header: header)
    }
    public func compress2D(x: Int, y: Int, precision: Int, header: Bool = true) -> [UInt8]? {
        let values = Array(self)
        return ZFPSession.compress2D(values, x: x, y: y, setParameters: { zfp_stream_set_precision($0, uint(precision)) }, header: header)
    }

    public func compress3D(x: Int, y: Int, z: Int, accuracy: Double, header: Bool = true) -> [UInt8]? {
        let values = Array(self)
        return ZFPSession.compress3D(values, x: x, y: y, z: z, setParameters: { zfp_stream_set_accuracy($0, accuracy) }, header: header)
    }
    public func compress3D(x: Int, y: Int, z: Int, precision: Int, header: Bool = true) -> [UInt8]? {
        let values = Array(self)
        return ZFPSession.compress3D(values, x: x, y: y, z: z, setParameters: { zfp_stream_set_precision($0, uint(precision)) }, header: header)
    }
}

public extension Sequence where Iterator.Element == UInt8 { // MARK: decompressing
    public func decompressFloatsWithHeader() -> [Float]? {
        let values = Array(self)
        return ZFPSession.decompressWithHeaderGuts(compressedData: values)
    }

    public func decompressDoublesWithHeader() -> [Double]? {
        let values = Array(self)
        return ZFPSession.decompressWithHeaderGuts(compressedData: values)
    }
}


public struct ZFPSession {

    // MARK: static functions

    // low-level functions, use methods on <Sequence> above
    fileprivate static func compress1D<EitherFloatOrDouble: FloatingPoint>(_ values: [EitherFloatOrDouble], setParameters: (UnsafeMutablePointer<zfp_stream>) -> (), header: Bool) -> [UInt8]? {
        return compressGuts(createFieldPointer: {
            var copyOnWriteValues = values
            return zfp_field_1d(&copyOnWriteValues, fieldTypeForType(EitherFloatOrDouble.self)!, UInt32(values.count))
        }, setParameters: setParameters, header: header)
    }

    fileprivate static func compress2D<EitherFloatOrDouble: FloatingPoint>(_ values: [EitherFloatOrDouble], x: Int, y: Int, setParameters: (UnsafeMutablePointer<zfp_stream>) -> (), header: Bool) -> [UInt8]? {
        return compressGuts(createFieldPointer: {
            var copyOnWriteValues = values
            return zfp_field_2d(&copyOnWriteValues, fieldTypeForType(EitherFloatOrDouble.self)!, UInt32(x), UInt32(y))
        }, setParameters: setParameters, header: header)
    }

    fileprivate static func compress3D<EitherFloatOrDouble: FloatingPoint>(_ values: [EitherFloatOrDouble], x: Int, y: Int, z: Int, setParameters: (UnsafeMutablePointer<zfp_stream>) -> (), header: Bool) -> [UInt8]? {
        return compressGuts(createFieldPointer: {
            var copyOnWriteValues = values
            return zfp_field_3d(&copyOnWriteValues, fieldTypeForType(EitherFloatOrDouble.self)!, UInt32(x), UInt32(y), UInt32(z))
        }, setParameters: setParameters, header: header)
    }


    // MARK: private
    private static func compressGuts(createFieldPointer: () -> UnsafeMutablePointer<zfp_field>?, setParameters: (UnsafeMutablePointer<zfp_stream>) -> (), header: Bool = true) -> [UInt8]? {
        guard let zfp = zfp_stream_open(nil) else { return nil }
        defer { zfp_stream_close(zfp) }

        setParameters(zfp)

        guard var fieldPointer = createFieldPointer() else { return nil }
        defer { zfp_field_free(fieldPointer) }

        let bufsize = zfp_stream_maximum_size(zfp, fieldPointer)
        var outputBuffer = [UInt8](repeating: 0, count: bufsize)

        let inputStream = stream_open(&outputBuffer, bufsize)
        defer { stream_close(inputStream) }
        zfp_stream_set_bit_stream(zfp, inputStream)
        zfp_stream_rewind(zfp)

        if header {
            zfp_write_header(zfp, fieldPointer, ZFP_HEADER_FULL)
        }
        let zfpsize = zfp_compress(zfp, fieldPointer)
        return Array(outputBuffer[0..<zfpsize])
    }

    fileprivate static func decompressWithHeaderGuts<EitherFloatOrDouble: FloatingPoint>(compressedData: [UInt8]) -> [EitherFloatOrDouble]? {
        let zfp = zfp_stream_open(nil)
        defer { zfp_stream_close(zfp) }

        var buffer = compressedData

        let inputStream = stream_open(&buffer, buffer.count * MemoryLayout<EitherFloatOrDouble>.size)
        defer { stream_close(inputStream) }
        zfp_stream_set_bit_stream(zfp, inputStream)
        zfp_stream_rewind(zfp)

        var field = zfp_field()
        zfp_read_header(zfp, &field, ZFP_HEADER_FULL)

        var outputBuffer = Array<EitherFloatOrDouble>(repeating: 0, count: zfp_field_size(&field, nil))
        outputBuffer.withUnsafeMutableBytes { field.data = $0.baseAddress }
        guard zfp_decompress(zfp, &field) > 0 else { return nil }
        return outputBuffer
    }

    private static func decompressGuts<EitherFloatOrDouble: FloatingPoint>(_ field: inout zfp_field, compressedData: [UInt8], accuracy: Double) -> [EitherFloatOrDouble]? {
        let zfp = zfp_stream_open(nil)
        defer { zfp_stream_close(zfp) }
        zfp_stream_set_accuracy(zfp, accuracy) // NOTE: this needs to match input values or CRAZY

        var buffer = compressedData

        let inputStream = stream_open(&buffer, buffer.count * MemoryLayout<EitherFloatOrDouble>.size)
        defer { stream_close(inputStream) }
        zfp_stream_set_bit_stream(zfp, inputStream)
        zfp_stream_rewind(zfp)

        var outputBuffer = Array<EitherFloatOrDouble>(repeating: 0, count: zfp_field_size(&field, nil))
        outputBuffer.withUnsafeMutableBytes { field.data = $0.baseAddress }
        guard zfp_decompress(zfp, &field) > 0 else { return nil }
        return outputBuffer
        // Array(UnsafeBufferPointer(start: field.data.bindMemory(to: EitherFloatOrDouble.self, capacity: 7), count: 7))
    }

    private static func fieldTypeForType(_ type: Any.Type) -> zfp_type? {
        if type == Float.self {
            return zfp_type_float
        } else if type == Double.self {
            return zfp_type_double
        } else {
            return nil
        }
    }
}
