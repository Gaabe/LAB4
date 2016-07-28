#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main () {
	
	int i, dataInt, padding, linhas, colunas, tarray, tlinhas, inicio, j;
	
	FILE *fp;
	
	unsigned char dataRAW[4];
	
	char *pixelArray;
		
	if ((fp=fopen("teste.bmp","r"))==NULL){
		fprintf(stderr, "Arquivo não pode ser aberto\n");
		exit(1);  
	}
	
	printf("Header de um arquivo bmp");
	fread(dataRAW, 1, 2, fp);
	printf("\nAssinatura: %c%c", dataRAW[0], dataRAW[1]);
	fread(dataRAW, 1, 4, fp);
	
	dataInt = 0;
	
	for (i = 3; i >= 0; i--){
		dataInt = (dataInt<<8) | dataRAW[i];
	}
	
	printf("\nTamanho do bitmap: %d Bytes", dataInt);
	
	fseek(fp,4,SEEK_CUR);															//Pula área reservada do header
	fread(dataRAW, 1, 4, fp);
	
	dataInt = 0;
	
	for (i = 3; i >= 0; i--){
		dataInt = (dataInt<<8) | dataRAW[i];
	}
	
	inicio = dataInt;
	
	printf("\nDistancia em bytes do inicio ate o pixel array: %d", inicio);
	
	fseek(fp,4,SEEK_CUR);															//Pula informação sobre o tamanho do DIB heade
	
	fread(dataRAW, 1, 4, fp);
	
	dataInt = 0;
	
	for (i = 3; i >= 0; i--){
		dataInt = (dataInt<<8) | dataRAW[i];
	}
	
	colunas = dataInt;
	
	fread(dataRAW, 1, 4, fp);
	
	dataInt = 0;
	
	for (i = 3; i >= 0; i--){
		dataInt = (dataInt<<8) | dataRAW[i];
	}
	
	linhas = dataInt;
	
	printf("\nA imagem tem tamanho %d x %d",colunas, linhas);
	
	tlinhas = ((((colunas*24) + 31)/32) * 4);
	
	tarray = tlinhas * linhas;
	
	padding = tlinhas - (colunas*3);
	
	printf("\nPadding tem tamanho %d bytes. O pixelArray tem %d bytes",padding,tarray);
	
	pixelArray = calloc(tarray, sizeof(char));
	
	fseek(fp,inicio,SEEK_SET);
	
	fread(pixelArray, 1, tarray, fp);
	
	fclose(fp);
	
	if ((fp=fopen("teste.lab4","w"))==NULL){
		fprintf(stderr, "Arquivo não pode ser aberto\n");
		exit(1);  
	}
	
	for (i=linhas-1; i >= 0; i--) {		
		fwrite(&pixelArray[i*tlinhas], 1, tlinhas - padding, fp);
		
	}
	
	fclose(fp);
}