#include <stdio.h>
#include <stdlib.h>    /* exit, malloc, calloc, etc. */
#include <getopt.h>    /* getopt */
#include <likwid.h>

#include "matriz.h"
#include "utils.h"

/**
 * Exibe mensagem de erro indicando forma de uso do programa e termina
 * o programa.
 */

static void usage(char *progname)
{
  fprintf(stderr, "Forma de uso: %s [ <ordem> ] \n", progname);
  exit(1);
}



/**
 * Programa principal
 * Forma de uso: matmult [ -n <ordem> ]
 * -n <ordem>: ordem da matriz quadrada e dos vetores
 *
 */

int main (int argc, char *argv[]) 
{
  LIKWID_MARKER_INIT;
  int n=DEF_SIZE;

  MatRow mRow_1, mRow_2, resMat, resMat2;
  Vetor vet, res, res2;
  rtime_t t1, t2, t3, t4;

  /* =============== TRATAMENTO DE LINHA DE COMANDO =============== */

  if (argc < 2)
    usage(argv[0]);

  n = atoi(argv[1]);

  /* ================ FIM DO TRATAMENTO DE LINHA DE COMANDO ========= */

  srandom(20232);

  res = geraVetor (n, 0); // (real_t *) malloc (n*sizeof(real_t));
  res2 = geraVetor (n, 0);

  resMat = geraMatRow(n, n, 1);
  resMat2 = geraMatRow(n, n, 1);

  mRow_1 = geraMatRow (n, n, 0);
  mRow_2 = geraMatRow (n, n, 0);

  vet = geraVetor (n, 0);

  if (!res || !res2 || !resMat || !resMat2 || !mRow_1 || !mRow_2 || !vet) {
    fprintf(stderr, "Falha em alocação de memória !!\n");
    liberaVetor ((void*) mRow_1);
    liberaVetor ((void*) mRow_2);
    liberaVetor ((void*) resMat);
    liberaVetor ((void*) resMat2);
    liberaVetor ((void*) vet);
    liberaVetor ((void*) res);
    liberaVetor ((void*) res2);
    exit(2);
  }
    
#ifdef _DEBUG_
    prnMat (mRow_1, n, n);
    prnMat (mRow_2, n, n);
    prnVetor (vet, n);
    printf ("=================================\n\n");
#endif /* _DEBUG_ */

    t3 = timestamp();
    LIKWID_MARKER_START("MVM 1");
    multMatVet (mRow_1, mRow_2, n, n, resMat);
    LIKWID_MARKER_STOP("MVM 1");
    t3 = timestamp() - t3;

    t1 = timestamp();
    LIKWID_MARKER_START("MMM 1");
    multMatMat (mRow_1, mRow_2, n, resMat);
    LIKWID_MARKER_STOP("MMM 1");
    t1 = timestamp() - t1;

    t4 = timestamp();
    LIKWID_MARKER_START("MVM 2");
    multMatVet_otim (mRow_1, mRow_2, n, n, resMat2);
    LIKWID_MARKER_STOP("MVM 2");
    t4 = timestamp() - t4;

    t2 = timestamp();
    LIKWID_MARKER_START("MMM 2");
    multMatMat_otim (mRow_1, mRow_2, n, resMat2);
    LIKWID_MARKER_STOP("MMM 2");
    t2 = timestamp() - t2;



#ifdef _DEBUG_
    prnVetor (res, n);
    prnMat (resMat, n, n);
#endif /* _DEBUG_ */

  liberaVetor ((void*) mRow_1);
  liberaVetor ((void*) mRow_2);
  liberaVetor ((void*) resMat);
  liberaVetor ((void*) resMat2);
  liberaVetor ((void*) vet);
  liberaVetor ((void*) res);
  liberaVetor ((void*) res2);

  fprintf(stdout, "%f, %f\n%f, %f\n", t1, t2, t3, t4);
  LIKWID_MARKER_CLOSE;
  return 0;
}

