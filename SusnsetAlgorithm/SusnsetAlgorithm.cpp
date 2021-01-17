#pragma once

#include "StdIncludes.h"
#include <xmmintrin.h>
#include <inttypes.h>

extern "C" double funct(long long n);

int main() {
    double value1 = funct(3);
    cout << value1;
    return 0;
    //Pedir los valores y pasarlos por parametros
}
