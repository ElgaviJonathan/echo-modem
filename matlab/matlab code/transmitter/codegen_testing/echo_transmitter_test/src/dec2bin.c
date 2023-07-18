/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * dec2bin.c
 *
 * Code generation for function 'dec2bin'
 *
 */

/* Include files */
#include "dec2bin.h"
#include "rt_nonfinite.h"
#include "rt_nonfinite.h"
#include <math.h>

/* Function Declarations */
static void decToBinScalar(double d, char s_data[], int s_size[2]);

static void toBin(double d, char s[64]);

/* Function Definitions */
static void decToBinScalar(double d, char s_data[], int s_size[2])
{
  int idx;
  int k;
  int pmax;
  int pmin;
  int pow2p;
  char sfull[64];
  char padval;
  boolean_T exitg1;
  toBin(d, sfull);
  if (d < 0.0) {
    idx = 0;
    k = 0;
    exitg1 = false;
    while ((!exitg1) && (k < 64)) {
      if (sfull[k] == '0') {
        idx = k + 1;
        exitg1 = true;
      } else {
        k++;
      }
    }
    if (idx == 0) {
      pow2p = 55;
      idx = 8;
    } else {
      idx--;
      if (65 - idx <= 4) {
        idx = 4;
      } else {
        idx = 65 - idx;
      }
      pmax = 31;
      pmin = 0;
      exitg1 = false;
      while ((!exitg1) && (pmax - pmin > 1)) {
        k = (pmin + pmax) >> 1;
        pow2p = 1 << k;
        if (pow2p == idx) {
          pmax = k;
          exitg1 = true;
        } else if (pow2p > idx) {
          pmax = k;
        } else {
          pmin = k;
        }
      }
      idx = 1 << pmax;
      if (idx >= 64) {
        idx = 64;
      }
      pow2p = 63 - idx;
    }
  } else {
    idx = 0;
    k = 0;
    exitg1 = false;
    while ((!exitg1) && (k < 64)) {
      if (sfull[k] == '1') {
        idx = k + 1;
        exitg1 = true;
      } else {
        k++;
      }
    }
    if (idx == 0) {
      idx = 64;
    }
    pow2p = idx - 2;
    idx = 65 - idx;
  }
  if (idx <= 3) {
    s_size[0] = 1;
    s_size[1] = 3;
  } else {
    s_size[0] = 1;
    s_size[1] = idx;
  }
  if (idx < 3) {
    pmax = 2 - idx;
    if (d < 0.0) {
      padval = '1';
    } else {
      padval = '0';
    }
    pmin = (unsigned char)(3 - idx);
    for (k = 0; k < pmin; k++) {
      s_data[k] = padval;
    }
  } else {
    pmax = -1;
  }
  pmin = (unsigned char)idx;
  for (k = 0; k < pmin; k++) {
    s_data[(pmax + k) + 1] = sfull[(pow2p + k) + 1];
  }
}

static void toBin(double d, char s[64])
{
  double b_d;
  double olddi;
  int j;
  char b[64];
  boolean_T carry;
  boolean_T exitg1;
  if (d < 0.0) {
    b_d = -d;
    for (j = 0; j < 64; j++) {
      b[j] = '0';
    }
    j = 64;
    exitg1 = false;
    while ((!exitg1) && (j > 0)) {
      olddi = b_d;
      b_d /= 2.0;
      b_d = floor(b_d);
      if (2.0 * b_d < olddi) {
        b[j - 1] = '1';
      }
      if (!(b_d > 0.0)) {
        exitg1 = true;
      } else {
        j--;
      }
    }
    for (j = 0; j < 64; j++) {
      s[j] = '1';
      if (b[j] == '1') {
        s[j] = '0';
      }
    }
    carry = true;
    for (j = 63; j >= 0; j--) {
      if (carry) {
        if (s[j] == '1') {
          s[j] = '0';
        } else {
          s[j] = '1';
          carry = false;
        }
      }
    }
  } else {
    b_d = d;
    for (j = 0; j < 64; j++) {
      s[j] = '0';
    }
    j = 64;
    exitg1 = false;
    while ((!exitg1) && (j > 0)) {
      olddi = b_d;
      b_d /= 2.0;
      b_d = floor(b_d);
      if (2.0 * b_d < olddi) {
        s[j - 1] = '1';
      }
      if (!(b_d > 0.0)) {
        exitg1 = true;
      } else {
        j--;
      }
    }
  }
}

void dec2bin(const double d[36], char s_data[], int s_size[2])
{
  double b_d;
  double b_ex;
  double ex;
  int smn_size[2];
  int smx_size[2];
  int b_idx;
  int c_idx;
  int idx;
  int k;
  int lenmn;
  int lenmx;
  int npad;
  int offset;
  int pow2p;
  int reqLen;
  char smn_data[64];
  char smx_data[64];
  char tmp_data[64];
  char padval;
  boolean_T b;
  boolean_T exitg1;
  b = !rtIsNaN(d[0]);
  if (b) {
    idx = 1;
  } else {
    idx = 0;
    k = 2;
    exitg1 = false;
    while ((!exitg1) && (k < 37)) {
      if (!rtIsNaN(d[k - 1])) {
        idx = k;
        exitg1 = true;
      } else {
        k++;
      }
    }
  }
  if (idx == 0) {
    ex = d[0];
    idx = 1;
  } else {
    ex = d[idx - 1];
    pow2p = idx + 1;
    for (k = pow2p; k < 37; k++) {
      b_d = d[k - 1];
      if (ex < b_d) {
        ex = b_d;
        idx = k;
      }
    }
  }
  if (b) {
    b_idx = 1;
  } else {
    b_idx = 0;
    k = 2;
    exitg1 = false;
    while ((!exitg1) && (k < 37)) {
      if (!rtIsNaN(d[k - 1])) {
        b_idx = k;
        exitg1 = true;
      } else {
        k++;
      }
    }
  }
  if (b_idx == 0) {
    b_ex = d[0];
    b_idx = 1;
  } else {
    b_ex = d[b_idx - 1];
    pow2p = b_idx + 1;
    for (k = pow2p; k < 37; k++) {
      b_d = d[k - 1];
      if (b_ex > b_d) {
        b_ex = b_d;
        b_idx = k;
      }
    }
  }
  decToBinScalar(ex, smx_data, smx_size);
  if (idx == b_idx) {
    s_size[0] = 36;
    s_size[1] = smx_size[1];
    pow2p = smx_size[1];
    for (lenmn = 0; lenmn < pow2p; lenmn++) {
      c_idx = lenmn * 36;
      for (lenmx = 0; lenmx < 36; lenmx++) {
        s_data[c_idx + lenmx] = smx_data[lenmn];
      }
    }
  } else {
    decToBinScalar(b_ex, smn_data, smn_size);
    lenmx = smx_size[1];
    lenmn = smn_size[1];
    c_idx = smx_size[1];
    reqLen = smn_size[1];
    if (c_idx >= reqLen) {
      reqLen = c_idx;
    }
    s_size[0] = 36;
    s_size[1] = reqLen;
    npad = reqLen - smx_size[1];
    if (d[idx - 1] < 0.0) {
      padval = '1';
    } else {
      padval = '0';
    }
    for (k = 0; k < npad; k++) {
      s_data[(idx + 36 * k) - 1] = padval;
    }
    for (k = 0; k < lenmx; k++) {
      s_data[(idx + 36 * (npad + k)) - 1] = smx_data[k];
    }
    npad = reqLen - smn_size[1];
    if (d[b_idx - 1] < 0.0) {
      padval = '1';
    } else {
      padval = '0';
    }
    for (k = 0; k < npad; k++) {
      s_data[(b_idx + 36 * k) - 1] = padval;
    }
    for (k = 0; k < lenmn; k++) {
      s_data[(b_idx + 36 * (npad + k)) - 1] = smn_data[k];
    }
    for (k = 0; k < 36; k++) {
      if ((k + 1 != b_idx) && (k + 1 != idx)) {
        b_d = d[k];
        toBin(b_d, smx_data);
        if (b_d < 0.0) {
          c_idx = 0;
          lenmn = 0;
          exitg1 = false;
          while ((!exitg1) && (lenmn < 64)) {
            if (smx_data[lenmn] == '0') {
              c_idx = lenmn + 1;
              exitg1 = true;
            } else {
              lenmn++;
            }
          }
          if (c_idx == 0) {
            offset = 55;
            c_idx = 8;
          } else {
            c_idx--;
            if (65 - c_idx <= 4) {
              c_idx = 4;
            } else {
              c_idx = 65 - c_idx;
            }
            lenmx = 31;
            lenmn = 0;
            exitg1 = false;
            while ((!exitg1) && (lenmx - lenmn > 1)) {
              offset = (lenmn + lenmx) >> 1;
              pow2p = 1 << offset;
              if (pow2p == c_idx) {
                lenmx = offset;
                exitg1 = true;
              } else if (pow2p > c_idx) {
                lenmx = offset;
              } else {
                lenmn = offset;
              }
            }
            lenmn = 1 << lenmx;
            if (lenmn >= 64) {
              c_idx = 64;
            } else {
              c_idx = lenmn;
            }
            offset = 63 - c_idx;
          }
        } else {
          c_idx = 0;
          lenmn = 0;
          exitg1 = false;
          while ((!exitg1) && (lenmn < 64)) {
            if (smx_data[lenmn] == '1') {
              c_idx = lenmn + 1;
              exitg1 = true;
            } else {
              lenmn++;
            }
          }
          if (c_idx == 0) {
            c_idx = 64;
          }
          offset = c_idx - 2;
          c_idx = 65 - c_idx;
        }
        if (reqLen >= c_idx) {
          lenmx = reqLen;
        } else {
          lenmx = c_idx;
        }
        if (c_idx < reqLen) {
          npad = (reqLen - c_idx) - 1;
          if (d[k] < 0.0) {
            padval = '1';
          } else {
            padval = '0';
          }
          for (lenmn = 0; lenmn <= npad; lenmn++) {
            tmp_data[lenmn] = padval;
          }
        } else {
          npad = -1;
        }
        pow2p = (unsigned char)c_idx;
        for (lenmn = 0; lenmn < pow2p; lenmn++) {
          tmp_data[(npad + lenmn) + 1] = smx_data[(offset + lenmn) + 1];
        }
        for (pow2p = 0; pow2p < lenmx; pow2p++) {
          s_data[k + 36 * pow2p] = tmp_data[pow2p];
        }
      }
    }
  }
}

/* End of code generation (dec2bin.c) */
