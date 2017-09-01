/*=================================================================
 *
 * EMD_WRAPPER.C
 *	        Wrapper for the earth-mover's distance function
 *
 * The calling syntax is:
 *
 *		[distance] = emd_wrapper(cost_array, supply, demand)
 *
 * This is a MEX-file for MATLAB.  
 *
 *=================================================================*/
#include "mex.h"
#include "emd.c"
#include <stdlib.h>

/* Input Arguments */

#define	COST	prhs[0]
#define	SUPPLY	prhs[1]
#define	DEMAND	prhs[2]


/* Output Arguments */

#define	DISTANCE	plhs[0]

float *fcost;
int costColumns, costRows;
float dist(feature_t *F1, feature_t *F2) {
	return fcost[(*F1)+costRows*(*F2)];
}


void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )
     
{ 
    unsigned int supplyRows, supplyColumns, demandRows, demandColumns;
    double *distance, *cost, *supply, *demand;
	float *fsupply, *fdemand;
    int i,j;
	feature_t *f1, *f2;
	signature_t sig1, sig2;
	
    /* Check for proper number of arguments */
    
    if (nrhs != 3) { 
	mexErrMsgTxt("3 input arguments required."); 
    } else if (nlhs > 1) {
	mexErrMsgTxt("Too many output arguments."); 
    } 
    
    /* Check the dimensions of input arguments. */ 
    
    costRows = mxGetM(COST); 
    costColumns = mxGetN(COST);
    supplyRows = mxGetM(SUPPLY); 
    supplyColumns = mxGetN(SUPPLY);
    demandRows = mxGetM(DEMAND); 
    demandColumns = mxGetN(DEMAND);

    if (!mxIsDouble(COST) || mxIsComplex(COST) || 
		!mxIsDouble(SUPPLY) || mxIsComplex(SUPPLY) ||
		!mxIsDouble(DEMAND) || mxIsComplex(DEMAND) ||
		(costRows != supplyColumns) || (costColumns != demandColumns) ||
		(supplyRows != 1) || (demandRows != 1)) { 
	mexErrMsgTxt("input argument sizes don't match"); 
    } 
    
    /* Create a matrix for the return argument */ 
    DISTANCE = mxCreateDoubleMatrix(1, 1, mxREAL); 
    
    /* Assign pointers to the various parameters */ 
    distance = mxGetPr(DISTANCE);
    cost = mxGetPr(COST); 
    supply = mxGetPr(SUPPLY);
	demand = mxGetPr(DEMAND);
	fcost = (float*)malloc(costRows * costColumns * sizeof(float));
	fsupply = (float*)malloc(supplyColumns * sizeof(float));
	fdemand = (float*)malloc(demandColumns * sizeof(float));
	f1 = (feature_t*)malloc(costRows * sizeof(feature_t));
	f2 = (feature_t*)malloc(costColumns * sizeof(feature_t));
	for (i = 0; i < costRows; i++)
		for (j = 0; j < costColumns; j++)
        	fcost[i+costRows*j] = (float)cost[i+costRows*j];
	for (i = 0; i < costRows; i++) {
		fsupply[i] = (float)supply[i];
		f1[i] = i;
	}
	for (j = 0; j < costColumns; j++) {
		fdemand[j] = (float)demand[j];
		f2[j] = j;
	}
	sig1.n = costRows;
	sig1.Features = f1;
	sig1.Weights = fsupply;
	sig2.n = costColumns;
	sig2.Features = f2;
	sig2.Weights = fdemand;

    /* Do the actual computations in a subroutine */
	*distance = (double) emd(&sig1, &sig2, dist, NULL, NULL);
	free(fcost);
	free(fsupply);
	free(fdemand);
	free(f1);
	free(f2);
    return;    
}

