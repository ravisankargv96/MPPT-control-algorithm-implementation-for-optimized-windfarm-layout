function B = calc_B(B_prev,ai,ai_prev,J,J_prev)
cons_1 = 1/((J - J_prev).'*(ai-ai_prev));
cons_2 = 1/((J-J_prev).'*B_prev*(J-J_prev));
B = B_prev + cons_1*(ai - ai_prev)*(ai - ai_prev).'...
    - cons_2*(B_prev*(J-J_prev)*(J-J_prev).'*B_prev.');
