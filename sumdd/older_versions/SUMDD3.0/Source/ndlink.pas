{
  This unit implements the interface with the processing library nd.dll.
  nd.dll is a library for calculating the multidimensional fast Fourier
  transform via a Split Radix implementation, with optimised low-level bits
  routines.

  © 2002-2005 Hector Laforcada
  2002-2004:
    Laboratorio de Cibernetica
    Facultad de Ingenieria - Bioingenieria
    Universidad Nacional de Entre Rios
    Entre Rios
    Argentina
  
  2005-present:
    Grupo de estudio en epilepsia
    Facultad de Medicina
    Universidad de Buenos Aires
    Capital Federal - Buenos Aires
    Argentina
    
  hlaforcada@softhome.net
  http://www.hlaforcada.tk

  nd.dll is based on an original work by Jorg Arndt
  arndt@jjj.de
  
  Thanks to my friend Javier Diaz Zamboni for all his support during the 
  developement of nd.dll and all the testing he did.
  javiereduardodiaz@gmail.com
}

unit ndlink;

interface

uses Windows; // UINT

const
  ND_MAX_DIMENSION = 5;
  NDDLL = 'nd.dll';

// Declared in "nd.h"

{ ndim_inv_fft

Usage:
 fr: Pointer to first real element in multidimensional array. If you're using
     a 2D matrix you would pass PDouble( @(RE_Matrix[0][0]) ).
 fi: Pointer to first imaginary element in multidimensional array. If you're
     using a 2D matrix you would pass PDouble( @(IM_Matrix[0][0]) ).
 ndim: dimension of multidimensional array. (1<ndim<6)
 ldn: pointer to first array log2 dimension. If you're using a 3D matrix, ldn
     should point to a 3 element array, such as:
     ldn3 : Array [0..2] of UINT;
     If the matrix is, say 512x512x16, the array must be:
     ldn3[0] := 9; ldn3[1] := 9; ldn3[2] := 4;
     In this case you would pass PUINT( @(ldn3[0]) ) as parameter.
 isign: Fourier basis exponent sign. Do not confuse with inverse transform! You
     must be consistent in the use of this sign, always keep the same value. I
     took the liberty of defining this sign as +1 to avoid messing up.
}
procedure ndim_inv_fft(const fr: PDouble; const fi: PDouble; const ndim: UINT;
                       const ldn: PUINT; const isign: Integer = 1); stdcall;

{ ndim_fft

Usage:
 fr: Pointer to first real element in multidimensional array. If you're using
     a 2D matrix you would pass PDouble( @(RE_Matrix[0][0]) ).
 fi: Pointer to first imaginary element in multidimensional array. If you're
     using a 2D matrix you would pass PDouble( @(IM_Matrix[0][0]) ).
 ndim: dimension of multidimensional array. (1<ndim<6)
 ldn: pointer to first array log2 dimension. If you're using a 3D matrix, ldn
     should point to a 3 element array, such as:
     ldn3 : Array [0..2] of UINT;
     If the matrix is, say 512x512x16, the array must be:
     ldn3[0] := 9; ldn3[1] := 9; ldn3[2] := 4;
     In this case you would pass PUINT( @(ldn3[0]) ) as parameter.
 isign: Fourier basis exponent sign. Do not confuse with inverse transform! You
     must be consistent in the use of this sign, always keep the same value. I
     took the liberty of defining this sign as +1 to avoid messing up.
}
procedure ndim_fft(const fr: PDouble; const fi: PDouble; const ndim: UINT;
                   const ldn: PUINT; const isign: Integer = 1); stdcall;


{ ndim_swap_fft:
  swaps elements to achieve the same arrangement given by
  MatLab's fftshift().
  That is: negative freqs ... 0 (dc) ... positive freqs

REMARKS:
  Only implemented for matrixes of 1,2 and 3 dimensions. Invoking with more
  than 3 dimension does nothing.

Usage:
 fr: Pointer to first real element in multidimensional array. If you're using
     a 2D matrix you would pass PDouble( @(RE_Matrix[0][0]) ).
 fi: Pointer to first imaginary element in multidimensional array. If you're
     using a 2D matrix you would pass PDouble( @(IM_Matrix[0][0]) ).
 ndim: dimension of multidimensional array. (1<ndim<4)
 ldn: pointer to first array log2 dimension. If you're using a 3D matrix, ldn
     should point to a 3 element array, such as:
     ldn3 : Array [0..2] of UINT;
     If the matrix is, say 512x512x16, the array must be:
     ldn3[0] := 9; ldn3[1] := 9; ldn3[2] := 4;
     In this case you would pass PUINT( @(ldn3[0]) ) as parameter.
}
procedure ndim_swap_fft(const fr: PDouble; const fi: PDouble; const ndim: UINT;
                        const ldn: PUINT); stdcall;

{ 2D SPECTRUM
Usage:
 fr: Pointer to first real element in 2D array.
     i.e. PDouble( @(RE_Matrix[0][0]) ).

 fi: Pointer to first imaginary element in 2D array.
     i.e. PDouble( @(IM_Matrix[0][0]) ).

 spec: Pointer to first element in 2D array.
     i.e. PDouble( @(Spectrum_Matrix[0][0]) ).
     NOTE: you must alloc memory for this matrix before calling this routine!

 ldn: points to a 2-element array containing the log2 of each dimension.
     ldn2 : Array [0..2] of UINT;
     If the matrix is, say 512x16, the array must be:
     ldn2[0] := 9; ldn2[1] := 4;
     In this case you would pass PUINT( @(ldn2[0]) ) as parameter.

 swap: integer that can be 0 or 1. If 0 then quadrants are not swapped,
     else quadrants 2-4 and 1-3 are swapped, leaving zero frequency centered.
     The default value is 0, so they're not swapped.

 normalize: integer that can be 0 or 1. 0 means no normalization.

 rangehigh, rangelow: if normalization <> 0 then all values are scaled to the
   range determined by (rangehigh - rangelow).
   The max and min values of spectrum are returned in rangelow and
   rangehigh respectively.
     IMPORTANT NOTE: normalization is applied ONLY IF rangehigh <> rangelow.
                     The max and min values are found no matter what.

 NOTE: Below this function takes two forms with different number of parameters,
       but don't worry, inside the dll the code is just once, but it's exported
       twice (with proper parameter matching) to allow this. I did this to avoid
       you the tedious work of declaring dummy variables in order to call the
       "short" version. Hope it's not too confusing.

}
procedure spectrum_2d(const fr: PDouble;
                      const fi: PDouble;
                      const spec: PDouble;
                      const ldn: PUINT;
                      const rangelow: PDouble;
                      const rangehigh: PDouble;
                      const swap: Integer = 0;
                      const normalize: Integer = 0
                      ); stdcall;

// overloaded version w/o normalization.
// You may still call the above version with normalize set to 0, it's the same.
procedure spectrum_2d_no_norm(
                      const fr: PDouble;
                      const fi: PDouble;
                      const spec: PDouble;
                      const ldn: PUINT;
                      const swap: Integer = 0
                      ); stdcall;


{ 2D PHASE
Usage:
 fr: Pointer to first real element in 2D array.
     i.e. PDouble( @(RE_Matrix[0][0]) ).
 fi: Pointer to first imaginary element in 2D array.
     i.e. PDouble( @(IM_Matrix[0][0]) ).
 phase: Pointer to first element in 2D array.
     i.e. PDouble( @(Phase_Matrix[0][0]) ).
     NOTE: you must alloc memory for this matrix before calling this routine!
 ldn: points to a 2-element array containing the log2 of each dimension.
     ldn2 : Array [0..2] of UINT;
     If the matrix is, say 512x16, the array must be:
     ldn2[0] := 9; ldn2[1] := 4;
     In this case you would pass PUINT( @(ldn2[0]) ) as parameter.
 swap: is an integer that can be 0 or 1. If 0 then quadrants are not swapped,
     else quadrants 2-4 and 1-3 are swapped, leaving zero frequency centered.
     The default value is 0, so they're not swapped.

}
procedure phase_2d(const fr: PDouble; const fi: PDouble; const phase: PDouble;
                   const ldn: PUINT; const swap: Integer = 0); stdcall;

implementation

procedure ndim_inv_fft(const fr: PDouble; const fi: PDouble; const ndim: UINT;
                       const ldn: PUINT; const isign: Integer = 1); stdcall;
                       external NDDLL name 'ndndim_inv_fft';

procedure ndim_fft(const fr: PDouble; const fi: PDouble; const ndim: UINT;
                   const ldn: PUINT; const isign: Integer = 1); stdcall;
                   external NDDLL name 'ndndim_fft';
                   
procedure ndim_swap_fft(const fr: PDouble; const fi: PDouble; const ndim: UINT;
                        const ldn: PUINT); stdcall; 
                        external NDDLL name 'ndndim_swap_fft';                  

procedure spectrum_2d(const fr: PDouble;
                      const fi: PDouble;
                      const spec: PDouble;
                      const ldn: PUINT;
                      const rangelow: PDouble;
                      const rangehigh: PDouble;
                      const swap: Integer = 0;
                      const normalize: Integer = 0
                      ); stdcall;
                      external NDDLL name 'ndspectrum_2d';

procedure spectrum_2d_no_norm (
                      const fr: PDouble;
                      const fi: PDouble;
                      const spec: PDouble;
                      const ldn: PUINT;
                      const swap: Integer = 0
                      ); stdcall;
                      external NDDLL name 'ndspectrum_2d_no_norm';

procedure phase_2d(const fr: PDouble; const fi: PDouble; const phase: PDouble;
                   const ldn: PUINT; const swap: Integer = 0); stdcall;
                   external NDDLL name 'ndphase_2d';

end.
