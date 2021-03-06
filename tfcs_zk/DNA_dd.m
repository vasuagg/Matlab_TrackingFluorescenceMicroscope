%% header.

%% 
%function DNA_dd calculate the theoretical FCS curve of three state model
%of hairpin folding, given the tau and parameter space ps. 

% note that state 1 is open state, state 2 is semiopen and state 3 is
% closed state. So Q1>Q2>Q3 for donor case. 


function DNAddtau=DNA_dd(t,ps)

syms k12 k21 Q2state pi1 pi2 tau Q3state trans2 trans3 k23 k32 Q1 Q2 W Q3 auto3 k_prdc g3;

%% transition matrix generation
Q3state=[-k12 k21 0;k12 -k21-k23 k32;0 k23 -k32];
trans3=expm(Q3state*tau);
k_prdc=k21*k32+k12*k32+k12*k23;
eq2=(k12*k32)/k_prdc;
eq1=(k21*k32)/k_prdc;
eq3=(k12*k23)/k_prdc;
%% average intensity
I_ave3=eq1*Q1+eq2*Q2+eq3*Q3;

%% correlation function
auto3=eq1*trans3(1,1)*Q1^2+eq1*trans3(1,2)*Q1*Q2+eq1*trans3(1,3)*Q1*Q3...
    +eq2*trans3(2,1)*Q2*Q1+eq2*trans3(2,2)*Q2^2+eq2*trans3(2,3)*Q2*Q3...
    +eq3*trans3(3,1)*Q3*Q1+eq3*trans3(3,2)*Q3*Q2+eq3*trans3(3,3)*Q3^2;
%% analytical expression for g3. 
g3=auto3/I_ave3^2-1;

%% putin numerical values.
vs_auto3=subs(auto3,{k12,k21,k23,k32,Q1,Q2,Q3},{ps.k12,ps.k21,ps.k23,ps.k32,ps.Q1,ps.Q2,ps.Q3});
v_I_ave3=subs(I_ave3,{k12,k21,k23,k32,Q1,Q2,Q3},{ps.k12,ps.k21,ps.k23,ps.k32,ps.Q1,ps.Q2,ps.Q3});

s_tau=t;
v_g3=double(subs(vs_auto3,tau,s_tau))/v_I_ave3^2-1;

figure;
semilogx(s_tau,v_g3)