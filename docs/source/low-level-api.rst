.. include:: defs.rst

.. _ll-api:

Low-Level C API
===============

The following topics are available:

* :ref:`ll-encoder`

  * :ref:`ll-1d-encoder`
  * :ref:`ll-2d-encoder`
  * :ref:`ll-3d-encoder`

.. _ll-encoder:

Encoder
-------

A function exists for encoding whole or partial blocks of each scalar type
and dimensionality.  These functions return the number of bits of compressed
storage for the block being encoded, or zero upon failure.

.. _ll-1d-encoder:

1D Data
^^^^^^^

.. c:function:: uint zfp_encode_block_int32_1(zfp_stream* stream, const int32* block)
.. c:function:: uint zfp_encode_block_int64_1(zfp_stream* stream, const int64* block)
.. c:function:: uint zfp_encode_block_float_1(zfp_stream* stream, const float* block)
.. c:function:: uint zfp_encode_block_double_1(zfp_stream* stream, const double* block)

  Encode 1D contiguous block of 4 values.

.. c:function:: uint zfp_encode_block_strided_int32_1(zfp_stream* stream, const int32* p, int sx)
.. c:function:: uint zfp_encode_block_strided_int64_1(zfp_stream* stream, const int64* p, int sx)
.. c:function:: uint zfp_encode_block_strided_float_1(zfp_stream* stream, const float* p, int sx)
.. c:function:: uint zfp_encode_block_strided_double_1(zfp_stream* stream, const double* p, int sx)

  Encode 1D complete block from strided array with stride *sx*.

.. c:function:: uint zfp_encode_partial_block_strided_int32_1(zfp_stream* stream, const int32* p, uint nx, int sx)
.. c:function:: uint zfp_encode_partial_block_strided_int64_1(zfp_stream* stream, const int64* p, uint nx, int sx)
.. c:function:: uint zfp_encode_partial_block_strided_float_1(zfp_stream* stream, const float* p, uint nx, int sx)
.. c:function:: uint zfp_encode_partial_block_strided_double_1(zfp_stream* stream, const double* p, uint nx, int sx)

  Encode 1D partial block of size *nx* from strided array with stride *sx*.

.. _ll-2d-encoder:

2D Data
^^^^^^^

.. c:function:: uint zfp_encode_block_int32_2(zfp_stream* stream, const int32* block)
.. c:function:: uint zfp_encode_block_int64_2(zfp_stream* stream, const int64* block)
.. c:function:: uint zfp_encode_block_float_2(zfp_stream* stream, const float* block)
.. c:function:: uint zfp_encode_block_double_2(zfp_stream* stream, const double* block)

/* encode 2D contiguous block of 4x4 values */
  Encode 1D contiguous block of 4 values.


/* encode 2D complete or partial block from strided array */
uint zfp_encode_partial_block_strided_int32_2(zfp_stream* stream, const int32* p, uint nx, uint ny, int sx, int sy);
uint zfp_encode_partial_block_strided_int64_2(zfp_stream* stream, const int64* p, uint nx, uint ny, int sx, int sy);
uint zfp_encode_partial_block_strided_float_2(zfp_stream* stream, const float* p, uint nx, uint ny, int sx, int sy);
uint zfp_encode_partial_block_strided_double_2(zfp_stream* stream, const double* p, uint nx, uint ny, int sx, int sy);
uint zfp_encode_block_strided_int32_2(zfp_stream* stream, const int32* p, int sx, int sy);
uint zfp_encode_block_strided_int64_2(zfp_stream* stream, const int64* p, int sx, int sy);
uint zfp_encode_block_strided_float_2(zfp_stream* stream, const float* p, int sx, int sy);
uint zfp_encode_block_strided_double_2(zfp_stream* stream, const double* p, int sx, int sy);

.. _ll-3d-encoder:

3D Data
^^^^^^^

/* encode 3D contiguous block of 4x4x4 values */
uint zfp_encode_block_int32_3(zfp_stream* stream, const int32* block);
uint zfp_encode_block_int64_3(zfp_stream* stream, const int64* block);
uint zfp_encode_block_float_3(zfp_stream* stream, const float* block);
uint zfp_encode_block_double_3(zfp_stream* stream, const double* block);

/* encode 3D complete or partial block from strided array */
uint zfp_encode_block_strided_int32_3(zfp_stream* stream, const int32* p, int sx, int sy, int sz);
uint zfp_encode_block_strided_int64_3(zfp_stream* stream, const int64* p, int sx, int sy, int sz);
uint zfp_encode_block_strided_float_3(zfp_stream* stream, const float* p, int sx, int sy, int sz);
uint zfp_encode_block_strided_double_3(zfp_stream* stream, const double* p, int sx, int sy, int sz);
uint zfp_encode_partial_block_strided_int32_3(zfp_stream* stream, const int32* p, uint nx, uint ny, uint nz, int sx, int sy, int sz);
uint zfp_encode_partial_block_strided_int64_3(zfp_stream* stream, const int64* p, uint nx, uint ny, uint nz, int sx, int sy, int sz);
uint zfp_encode_partial_block_strided_float_3(zfp_stream* stream, const float* p, uint nx, uint ny, uint nz, int sx, int sy, int sz);
uint zfp_encode_partial_block_strided_double_3(zfp_stream* stream, const double* p, uint nx, uint ny, uint nz, int sx, int sy, int sz);

Decoder
-------

Each function below decompresses a single block and returns the number of bits
of compressed storage consumed.  See corresponding encoder functions above for
further details.


/* decode 1D contiguous block of 4 values */
uint zfp_decode_block_int32_1(zfp_stream* stream, int32* block);
uint zfp_decode_block_int64_1(zfp_stream* stream, int64* block);
uint zfp_decode_block_float_1(zfp_stream* stream, float* block);
uint zfp_decode_block_double_1(zfp_stream* stream, double* block);

/* decode 1D complete or partial block from strided array */
uint zfp_decode_block_strided_int32_1(zfp_stream* stream, int32* p, int sx);
uint zfp_decode_block_strided_int64_1(zfp_stream* stream, int64* p, int sx);
uint zfp_decode_block_strided_float_1(zfp_stream* stream, float* p, int sx);
uint zfp_decode_block_strided_double_1(zfp_stream* stream, double* p, int sx);
uint zfp_decode_partial_block_strided_int32_1(zfp_stream* stream, int32* p, uint nx, int sx);
uint zfp_decode_partial_block_strided_int64_1(zfp_stream* stream, int64* p, uint nx, int sx);
uint zfp_decode_partial_block_strided_float_1(zfp_stream* stream, float* p, uint nx, int sx);
uint zfp_decode_partial_block_strided_double_1(zfp_stream* stream, double* p, uint nx, int sx);

/* decode 2D contiguous block of 4x4 values */
uint zfp_decode_block_int32_2(zfp_stream* stream, int32* block);
uint zfp_decode_block_int64_2(zfp_stream* stream, int64* block);
uint zfp_decode_block_float_2(zfp_stream* stream, float* block);
uint zfp_decode_block_double_2(zfp_stream* stream, double* block);

/* decode 2D complete or partial block from strided array */
uint zfp_decode_block_strided_int32_2(zfp_stream* stream, int32* p, int sx, int sy);
uint zfp_decode_block_strided_int64_2(zfp_stream* stream, int64* p, int sx, int sy);
uint zfp_decode_block_strided_float_2(zfp_stream* stream, float* p, int sx, int sy);
uint zfp_decode_block_strided_double_2(zfp_stream* stream, double* p, int sx, int sy);
uint zfp_decode_partial_block_strided_int32_2(zfp_stream* stream, int32* p, uint nx, uint ny, int sx, int sy);
uint zfp_decode_partial_block_strided_int64_2(zfp_stream* stream, int64* p, uint nx, uint ny, int sx, int sy);
uint zfp_decode_partial_block_strided_float_2(zfp_stream* stream, float* p, uint nx, uint ny, int sx, int sy);
uint zfp_decode_partial_block_strided_double_2(zfp_stream* stream, double* p, uint nx, uint ny, int sx, int sy);

/* decode 3D contiguous block of 4x4x4 values */
uint zfp_decode_block_int32_3(zfp_stream* stream, int32* block);
uint zfp_decode_block_int64_3(zfp_stream* stream, int64* block);
uint zfp_decode_block_float_3(zfp_stream* stream, float* block);
uint zfp_decode_block_double_3(zfp_stream* stream, double* block);

/* decode 3D complete or partial block from strided array */
uint zfp_decode_block_strided_int32_3(zfp_stream* stream, int32* p, int sx, int sy, int sz);
uint zfp_decode_block_strided_int64_3(zfp_stream* stream, int64* p, int sx, int sy, int sz);
uint zfp_decode_block_strided_float_3(zfp_stream* stream, float* p, int sx, int sy, int sz);
uint zfp_decode_block_strided_double_3(zfp_stream* stream, double* p, int sx, int sy, int sz);
uint zfp_decode_partial_block_strided_int32_3(zfp_stream* stream, int32* p, uint nx, uint ny, uint nz, int sx, int sy, int sz);
uint zfp_decode_partial_block_strided_int64_3(zfp_stream* stream, int64* p, uint nx, uint ny, uint nz, int sx, int sy, int sz);
uint zfp_decode_partial_block_strided_float_3(zfp_stream* stream, float* p, uint nx, uint ny, uint nz, int sx, int sy, int sz);
uint zfp_decode_partial_block_strided_double_3(zfp_stream* stream, double* p, uint nx, uint ny, uint nz, int sx, int sy, int sz);

Utility Functions
-----------------

/* convert dims-dimensional contiguous block to 32-bit integer type */
void zfp_promote_int8_to_int32(int32* oblock, const int8* iblock, uint dims);
void zfp_promote_uint8_to_int32(int32* oblock, const uint8* iblock, uint dims);
void zfp_promote_int16_to_int32(int32* oblock, const int16* iblock, uint dims);
void zfp_promote_uint16_to_int32(int32* oblock, const uint16* iblock, uint dims);

/* convert dims-dimensional contiguous block from 32-bit integer type */
void zfp_demote_int32_to_int8(int8* oblock, const int32* iblock, uint dims);
void zfp_demote_int32_to_uint8(uint8* oblock, const int32* iblock, uint dims);
void zfp_demote_int32_to_int16(int16* oblock, const int32* iblock, uint dims);
void zfp_demote_int32_to_uint16(uint16* oblock, const int32* iblock, uint dims);

#endif
