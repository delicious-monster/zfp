.. include:: defs.rst
.. _overview:

Overview
========

The |zfp| software consists of three main components: a C library for
compressing whole arrays (or smaller pieces of arrays); C++ classes
that implement compressed arrays; and a command-line compression tool
and other code examples.  |zfp| has also been incorporated into several
independently developed plugins for interfacing |zfp| with popular
I/O libraries and visualization tools such as
`HDF5 <https://support.hdfgroup.org/HDF5/>`_,
`ADIOS <https://www.olcf.ornl.gov/center-projects/adios/>`_, and
`VTK <http://www.vtk.org/>`_.

The typical user will interact with |zfp| via one or more of those
components, specifically

* Via the :ref:`C API <api>` when doing I/O in an application or
  otherwise performing data (de)compression online.

* Via |zfp|'s C++ :ref:`compressed array classes <arrays>` when
  performing computations on very large arrays, e.g. in visualization,
  data analysis, or even in numerical simulation.

* Via the |zfp| :ref:`command-line tool <zfpcmd>` when compressing
  binary files offline.

* Via one of the I/O libraries or visualization tools that support |zfp|.

In all cases, it is important to know how to use |zfp|'s
:ref:`compression modes <modes>` as well as what the
:ref:`limitations <limitations>` of |zfp| are.  Although it is not critical
to understand the
:ref:`compression algorithm <algorithm>` itself, having some familiarity with
its major components may help understand what to expect and how |zfp|'s
parameters influence the result.

**More text here to provide a brief overview of how zfp works.**
