COMMENT
/**
 * @file TsodyksMarkram_AMPA_NMDA.mod
 * @brief An AMPA and NMDA glutamate receptor model with short-term depression
 * and facilitation
 * @author emuller
 * @date 2017-05-11
 * @remark Copyright © BBP/EPFL 2005-2014; All rights reserved. 
 */
ENDCOMMENT


TITLE AMPA and NMDA glutamate receptor with TM short-term dynamics

COMMENT
AMPA and NMDA glutamate receptor conductance using a dual-exponential profile
and incorporating Tsodyks-Markram short-term dynamics
ENDCOMMENT

: Definition of variables which may be accesses by the user 
NEURON {
    THREADSAFE

    POINT_PROCESS TsodyksMarkram_AMPA_NMDA
    RANGE tau_r_AMPA, tau_d_AMPA
    RANGE tau_r_NMDA, tau_d_NMDA
    RANGE mg, gmax_AMPA, gmax_NMDA
    RANGE tau_rec, tau_facil, U1
    RANGE i, i_AMPA, i_NMDA, g_AMPA, g_NMDA, g, e, R
    NONSPECIFIC_CURRENT i
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

    : Parameters of TM model
    tau_rec = 200      (ms)  : time constant of recovery from depression
    tau_facil = 200    (ms)  : time constant of facilitation
    U1 = 0.5           (1)   : baseline release probability
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

: State variables for the TM model
    R            : Running fraction of available vesicles
    Use          : Running value of the release probability
}

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

    R' = (1-R)/tau_rec
    Use' = -Use/tau_facil
}

: Block to be executed for a pre-synaptic spike event
NET_RECEIVE (weight) {
    LOCAL A
    
    Use = Use + U1*(1-Use)
    A = Use*R
    R = R - A
    
    A_AMPA = A_AMPA + A*weight*factor_AMPA
    B_AMPA = B_AMPA + A*weight*factor_AMPA
    A_NMDA = A_NMDA + A*weight*factor_NMDA
    B_NMDA = B_NMDA + A*weight*factor_NMDA
}

