// ===== Parâmetros principais =====
diametro = 80;
espessura = 3;
furo_central = 7;

num_furos_borda = 6;
diametro_furo_borda = 4;
raio_furos_borda = 34;

num_canais = 5;
profundidade_canal = 1.2;
largura_canal = 5;

$fn = 60; // Qualidade global

// ===== Construção Final =====
difference() {
    // Disco principal
    cylinder(d=diametro, h=espessura);

    // Furo central
    translate([0,0,-1])
        cylinder(d=furo_central, h=espessura+2);

    // Furos na borda (semi-esféricos/furos como na foto)
    for (i = [0:num_furos_borda-1]) {
        rotate([0, 0, i * 360/num_furos_borda])
        translate([raio_furos_borda, 0, espessura])
            sphere(d=diametro_furo_borda + 1); // Sphere dá o efeito de "cova" da foto
    }

    // Canais curvos (Vórtice)
    for (i = [0:num_canais-1]) {
        rotate([0, 0, i * 360/num_canais])
            canal_curvo();
    }
}

// ===== Módulo do canal curvo =====
module canal_curvo() {
    // Subtrai apenas no topo do disco
    translate([0, 0, espessura - profundidade_canal + 0.01])
        linear_extrude(height = profundidade_canal + 0.1)
            curva_vortex();
}

// ===== Forma 2D da curva (Minhoca) =====
module curva_vortex() {
    // Pontos que definem a "espiral" saindo do centro para a borda
    // Ajustados para não tocar nem o centro nem a borda externa
    p = [
        [7, 3],
        [10, 8],
        [16, 14],
        [23, 16],
        [29, 14]
    ];

    // Conecta os pontos em pares para manter a curvatura fiel
    for (i = [0 : len(p) - 2]) {
        hull() {
            translate(p[i]) circle(d=largura_canal);
            translate(p[i+1]) circle(d=largura_canal);
        }
    }
}