    %%
    function proiect_biliard_complet()
    % --- DATE DE INTRARE (Input) ---
    L = 10; H = 5;              % Dimensiunile mesei
    raza = 0.2;                 % Raza bilelor
    pos_alba = [0.5, 2];        % Poziția de start bila albă
    pos_colorata = [2, 2.5];      % Poziția bila colorată
    v0_mag = 9;                % Viteza inițială (puterea)
    unghi_tinta = 15;            % Unghiul în grade spre care tragi (față de orizontală)
    frecare = 0.9;              % Decelerarea (m/s^2)
    dt = 0.015;                 % Pasul de timp al simulării

    % Conversie unghi în vector viteză inițial
    v_alba = [v0_mag * cosd(unghi_tinta), v0_mag * sind(unghi_tinta)];
    v_colorata = [0, 0];

    % --- CONFIGURARE GRAFICĂ ---
    fig = figure('Color', [0.2 0.2 0.2], 'Name', 'Simulare Biliard Pro');
    ax = axes('XLim', [0 L], 'YLim', [0 H], 'Color', [0.1 0.5 0.1]);
    hold on; axis equal;
    
    % Desenare pereți
    rectangle('Position', [0 0 L H], 'EdgeColor', [0.5 0.3 0.1], 'LineWidth', 10);
    
    % Creare obiecte bile
    theta = linspace(0, 2*pi, 30);
    cx = raza * cos(theta); cy = raza * sin(theta);
    h_alba = fill(pos_alba(1)+cx, pos_alba(2)+cy, 'w');
    h_colorata = fill(pos_colorata(1)+cx, pos_colorata(2)+cy, 'r');

    % --- SIMULARE ---
    impact_avut_loc = false;
    running = true;

    while running
        % 1. Actualizare poziții
        pos_alba = pos_alba + v_alba * dt;
        pos_colorata = pos_colorata + v_colorata * dt;

        % 2. Detecție Coliziune între bile
        dist = norm(pos_alba - pos_colorata);
        if ~impact_avut_loc && dist <= 2*raza
            [v_alba, v_colorata] = calcul_impact(pos_alba, pos_colorata, v_alba);
            impact_avut_loc = true;
        end

        % 3. Detecție Pereți (Ricoșeu)
        [pos_alba, v_alba] = verifica_pereti(pos_alba, v_alba, L, H, raza);
        [pos_colorata, v_colorata] = verifica_pereti(pos_colorata, v_colorata, L, H, raza);

        % 4. Aplicare Frecare
        v_alba = aplica_frecare(v_alba, frecare, dt);
        v_colorata = aplica_frecare(v_colorata, frecare, dt);

        % 5. Actualizare Grafică
        set(h_alba, 'XData', pos_alba(1)+cx, 'YData', pos_alba(2)+cy);
        set(h_colorata, 'XData', pos_colorata(1)+cx, 'YData', pos_colorata(2)+cy);
        
        drawnow;
        if norm(v_alba) < 0.1 && norm(v_colorata) < 0.1, running = false; end
    end
end

% --- FUNCȚII AUXILIARE ---

function [v1_new, v2_new] = calcul_impact(p1, p2, v1)
    % Calculează vitezele imediat după impact
    n = (p2 - p1) / norm(p2 - p1); % Vectorul normal (linia centrelor)
    v1n = dot(v1, n);              % Proiecția vitezei pe normală
    v1t = v1 - v1n * n;            % Componenta tangențială
    
    v2_new = v1n * n;              % Bila 2 preia componenta normală
    v1_new = v1t;                  % Bila 1 rămâne cu cea tangențială
end

function [p, v] = verifica_pereti(p, v, L, H, r)
    % Ricoșeu simplu din pereți
    if p(1)-r < 0 || p(1)+r > L, v(1) = -v(1); end
    if p(2)-r < 0 || p(2)+r > H, v(2) = -v(2); end
    % Ajustare poziție pentru a nu rămâne blocat în perete
    p(1) = max(r, min(L-r, p(1)));
    p(2) = max(r, min(H-r, p(2)));
end

function v = aplica_frecare(v, f, dt)
    speed = norm(v);
    if speed > 0
        new_speed = max(0, speed - f * dt);
        v = v * (new_speed / speed);
    end
end

