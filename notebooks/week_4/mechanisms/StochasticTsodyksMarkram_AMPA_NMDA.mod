COMMENT
/**
 * @file TsodyksMarkram_AMPA_NMDA.mod
 * @brief An AMPA and NMDA glutamate receptor model with Tsodyks-Markram dynamics of the releasible pool
 * @author emuller
 * @date 2017-05-11
 * @remark Copyright © BBP/EPFL 2005-2014; All rights reserved. 
 */
ENDCOMMENT


TITLE AMPA and NMDA glutamate receptor with Stochastic Tsodyks-Markram dynamics

COMMENT
AMPA and NMDA glutamate receptor conductance using a dual-exponential profile
and with stochastic Tsodyks-Markram dynamics of the releasible pool.

This new model is based on Fuhrmann et al. 2002, and has the following properties:

1) No consumption on failure.  
2) No release just after release until recovery.
3) Same ensemble averaged trace as deterministic/canonical Tsodyks-Markram 
   using same parameters determined from experiment.

The synapse is implemented as a uni-vesicular (generalization to
multi-vesicular should be straight-forward) 2-state Markov process.
The states are {1=recovered, 0=unrecovered}.

For a pre-synaptic spike or external spontaneous release trigger
event, the synapse will only release if it is in the recovered state,
and with probability Use (which follows facilitation dynamics).  If it
releases, it will transition to the unrecovered state.  Recovery is as
a Poisson process with rate 1/tau_rec.

ENDCOMMENT

: Definition of variables which may be accesses by the user 
NEURON {
    THREADSAFE

    POINT_PROCESS StochasticTsodyksMarkram_AMPA_NMDA
    RANGE tau_r_AMPA, tau_d_AMPA
    RANGE tau_r_NMDA, tau_d_NMDA
    RANGE mg, gmax_AMPA, gmax_NMDA
    RANGE i, i_AMPA, i_NMDA, g_AMPA, g_NMDA, g, e, R
    RANGE tau_rec, tau_facil, U1
    NONSPECIFIC_CURRENT i

    : For user defined random number generator
    POINTER rng
}

: Definition of constants which may be set by the user
PARAMETER {

    tau_r_AMPA = 0.2   (ms)  : Dual-exponential conductance profile
    tau_d_AMPA = 1.7   (ms)  : IMPORTANT: tau_r < tau_d
    tau_r_NMDA = 0.29  (ms)  : Dual-exponential conductance profile
    tau_d_NMDA = 43    (ms)  : IMPORTANT: tau_r < tau_d

    e = 0              (mV)  : AMPA and NMDA reversal potential
    mg = 1             (mM)  : Initial concentration of mg2+
    mggate
    
    gmax_AMPA = .001   (uS)  : Weight conversion factor (from nS to uS)
    gmax_NMDA = .001   (uS)  : Weight conversion factor (from nS to uS)

    : Parameters for Tsodyks-Markram (TM) model of vesicle pool dynamics
    tau_rec = 600      (ms)  : time constant of vesicle pool recovery
    tau_facil = 10     (ms)  : time constant of release facilitation relaxation
    U1 = 0.5           (1)   : release probability in the absence of facilitation

}

: Declaration of state variables 
STATE {

    A_AMPA       : AMPA state variable to construct the dual-exponential profile
                 : rise kinetics with tau_r_AMPA

    B_AMPA       : AMPA state variable to construct the dual-exponential profile
                 : decay kinetics with tau_d_AMPA

    A_NMDA       : NMDA state variable to construct the dual-exponential profile
                 : rise kinetics with tau_r_NMDA

    B_NMDA       : NMDA state variable to construct the dual-exponential profile
                 : decay kinetics with tau_d_NMDA

    : State variables for TM model
    Use          : running release probability

}

: This is "inline" code in the C programming language 
: needed to manage user defined random number generators
VERBATIM

#include<stdlib.h>
#include<stdio.h>
#include<math.h>

double nrn_random_pick(void* r);
void* nrn_random_arg(int argpos);

ENDVERBATIM


: Declaration of variables that are computed, e.g. in the BREAKPOINT block
ASSIGNED {
    v (mV)
    i (nA)
    i_AMPA (nA)
    i_NMDA (nA)
    g_AMPA (uS)
    g_NMDA (uS)
    g (uS)
    factor_AMPA
    factor_NMDA
    rng
    R : running fraction of vesicle pool
}

: Definition of initial conditions
INITIAL{
    LOCAL tp_AMPA, tp_NMDA     : Declaration of some local variables

    : Zero receptor rise and fall kinetics variables
    A_AMPA = 0
    B_AMPA = 0

    A_NMDA = 0
    B_NMDA = 0

    : Compute constants needed to normalize the dual-exponential receptor dynamics

    : Expression for time to peak of the AMPA dual-exponential conductance
    tp_AMPA = (tau_r_AMPA*tau_d_AMPA)/(tau_d_AMPA-tau_r_AMPA)*log(tau_d_AMPA/tau_r_AMPA)
    : Expression for time to peak of the NMDA dual-exponential conductance
    tp_NMDA = (tau_r_NMDA*tau_d_NMDA)/(tau_d_NMDA-tau_r_NMDA)*log(tau_d_NMDA/tau_r_NMDA)

    : AMPA Normalization factor - so that when t = tp_AMPA, gsyn = gpeak
    factor_AMPA = -exp(-tp_AMPA/tau_r_AMPA)+exp(-tp_AMPA/tau_d_AMPA) 
    factor_AMPA = 1/factor_AMPA
    : NMDA Normalization factor - so that when t = tp_NMDA, gsyn = gpeak
    factor_NMDA = -exp(-tp_NMDA/tau_r_NMDA)+exp(-tp_NMDA/tau_d_NMDA) 
    factor_NMDA = 1/factor_NMDA

    R = 1
    Use = 0

}

: Declare method to propagate the state variables in time
BREAKPOINT {

    : Specify to solve system of equations "odes", declared below (DERIVATIVE block)
    : "cnexp" specifies the intergration method, it is
    : an implicit integration method that is stable even for stiff systems
    SOLVE odes METHOD cnexp

    : Compute and assign quantities which depend on the state variables

    : Compute the time varying AMPA receptor conductance as 
    : the difference of state variables B_AMPA and A_AMPA
    g_AMPA = gmax_AMPA*(B_AMPA-A_AMPA) 

    : NMDA is similar, but with a Magnesium block term: mggate
    : Magneisum block kinetics due to Jahr & Stevens 1990
    mggate = 1 / (1 + exp(0.062 (/mV) * -(v)) * (mg / 3.57 (mM))) 
    g_NMDA = mggate*gmax_NMDA*(B_NMDA-A_NMDA)  

    : Total conductance
    g = g_AMPA + g_NMDA

    : Compute the AMPA and NMDA specific currents
    i_AMPA = g_AMPA*(v-e) 
    i_NMDA = g_NMDA*(v-e) 

    : Compute the total current
    i = i_AMPA + i_NMDA
}

: Declaration of ODEs solved for in the BREAKPOINT block
DERIVATIVE odes {
    A_AMPA' = -A_AMPA/tau_r_AMPA
    B_AMPA' = -B_AMPA/tau_d_AMPA
    A_NMDA' = -A_NMDA/tau_r_NMDA
    B_NMDA' = -B_NMDA/tau_d_NMDA
    Use' = -Use/tau_facil
}

: Block to be executed for a pre-synaptic spike event
NET_RECEIVE (weight, tsyn (ms)) {
    LOCAL A, result, Psurv

    INITIAL{
        tsyn=t
    }

    Use = Use + U1*(1-Use) : Update of release probability 

    if (R == 0) {
        : probability of survival of unrecovered state based on Poisson recovery with rate 1/tau_rec
        Psurv = exp(-(t-tsyn)/tau_rec)
        result = urand()
        if (result>Psurv) {
            : recover      
            R = 1     
        }
        else {
            : probability of survival must now be from this interval
	    tsyn = t
        }
    }	   
	   
    if (R == 1) {
        result = urand()
        if (result<Use) {
	    : release!
   	    tsyn = t
	    R = 0
            A_AMPA = A_AMPA + weight*factor_AMPA
            B_AMPA = B_AMPA + weight*factor_AMPA
            A_NMDA = A_NMDA + weight*factor_NMDA
            B_NMDA = B_NMDA + weight*factor_NMDA
        }

    }

}

: Black magic to support use defined random number generators
: No user serviceable code below this point
PROCEDURE setRNG() {
VERBATIM
    {
        /**
         * This function takes a NEURON Random object declared in hoc and makes it usable by this mod file.
         * Note that this method is taken from Brett paper as used by netstim.hoc and netstim.mod
         * which points out that the Random must be in uniform(1) mode
         */
        void** pv = (void**)(&_p_rng);
        if( ifarg(1)) {
            *pv = nrn_random_arg(1);
        } else {
            *pv = (void*)0;
        }
    }
ENDVERBATIM
}

FUNCTION urand() {
VERBATIM
        double value;
        if (_p_rng) {
                /*
                :Supports separate independent but reproducible streams for
                : each instance. However, the corresponding hoc Random
                : distribution MUST be set to Random.uniform(0,1)
                */
                value = nrn_random_pick(_p_rng);
                //printf("random stream for this simulation = %lf\n",value);
                return value;
        }else{
ENDVERBATIM
                : the old standby. Cannot use if reproducible parallel sim
                : independent of nhost or which host this instance is on
                : is desired, since each instance on this cpu draws from
                : the same stream
                value = scop_random(1)
VERBATIM
        }
ENDVERBATIM
        urand = value
}



