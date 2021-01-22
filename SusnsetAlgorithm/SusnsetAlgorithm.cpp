#pragma once

#include "StdIncludes.h"
#include <xmmintrin.h>
#include <inttypes.h>
#include <string>

extern "C" double _day;//
extern "C" double _month;//
extern "C" double _year;//
extern "C" double latitude;
extern "C" double longitude;
extern "C" int _hour;//
extern "C" int _minutes;//
extern "C" int _opcion;//
extern "C" double localT;
extern "C" double zenith;
extern "C" int sunsetAlgo(double latitud, double longitud, double zenith);

float zenithAdjustment;

int main() {
	int a, opcion_zenith;
	float lat2, lon2;
	printf("Digite el dia: ");
	scanf_s("%lf", &_day);
	if (_day < 1 || _day > 31) {
		printf("Por favor digite un dia correcto");
		return 0;
	}
	printf("Digite el mes: ");
	scanf_s("%lf", &_month);
	if (_month < 1 || _month > 12) {
		printf("Por favor digite un mes correcto");
		return 0;
	}
	printf("Digite el year: ");
	scanf_s("%lf", &_year);
	printf("%f / %f / %f \n", _day, _month, _year);
	printf("Digite la latitud: ");
	scanf_s("%f", &lat2);
	if (lat2 < -90 || lat2 > 90) {
		printf("Por favor digite una latitud correcta");
		return 0;
	}
	printf("Digite la longitud: ");
	scanf_s("%f", &lon2);
	if (lon2 < -180 || lon2 > 180) {
		printf("Por favor digite una longitud correcta");
		return 0;
	}
	printf("Digite el cenital deseado:\n1. Oficial 90.83 grados\n2. Civil 96 grados\n3. Nautico 102 grados\n4. Astronomico 108 grados\n");
	scanf_s("%d", &opcion_zenith);
	switch (opcion_zenith) {
	case 1:
		zenithAdjustment = 90.83;
		break;
	case 2:
		zenithAdjustment = 96;
		break;
	case 3:
		zenithAdjustment = 102;
		break;
	case 4:
		zenithAdjustment = 108;
		break;
	default:
		printf("Por favor digite una opcion correcta");
		return 0;
	}
	printf("Digite 1 para calcular la salida del sol, o 2 para la puesta del sol: ");
	scanf_s("%d", &_opcion);
	if (_opcion != 1 && _opcion != 2) {
		printf("Por favor digite una opcion correcta");
		return 0;
	}
	a = sunsetAlgo(lat2, lon2, zenithAdjustment);
	if (a == 0) {
		printf("Hora: %d Minutos: %d", _hour,_minutes);
	}
	else if (a == 1) {
		printf("El sol no sale en el lugar y fecha indicados");
	}
	else if (a == -1) {
		printf("El sol no se pone en el lugar y fecha indicados");
	}
	return 0;
}
