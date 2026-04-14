// ===== Parâmetros Globais =====
$fn = 100;

// Dimensões do Disco
diametro = 80;
espessura = 3;
furo_central = 7;

// Cores para visualização
cor_disco = "white";
cor_rosa = [1, 0.07, 0.57]; // Hot Pink

// ===== Renderização Final =====
union() {
    difference() {
        // 1. CORPO DO DISCO
        color(cor_disco) 
            cylinder(d=diametro, h=espessura, center=true);

        // 2. FURO CENTRAL (Atravessa tudo)
        cylinder(d=furo_central, h=espessura + 2, center=true);

        // 3. FACE SUPERIOR: AS FENDAS (VORTEX)
        // Mantendo o progresso anterior que você gostou
        color("lightgrey")
        for (i = [0:4]) {
            rotate([0, 0, i * 72])
            translate([0, 0, espessura/2 - 1.2]) // Profundidade de 1.2mm
                linear_extrude(height = 2)
                    curva_vortex_2d();
        }

        // 4. FACE SUPERIOR: COVAS NA BORDA
        for (i = [0:5]) {
            rotate([0, 0, i * 60])
            translate([34, 0, espessura/2])
                sphere(d=5);
        }
        
        // 5. FACE INFERIOR: O ESBOÇO DO CIRCUITO (PARA PINTURA)
        // Criamos um baixo-relevo bem fino para a máquina de pintura seguir
        rotate([180, 0, 0]) // Vira para a face de baixo
        translate([0, 0, espessura/2 - 0.3])
            linear_extrude(height = 1)
                desenho_circuito_elaborado();
    }

    // Visualização da Cor Rosa (opcional para ver no OpenSCAD)
    color(cor_rosa)
    rotate([180, 0, 0])
    translate([0, 0, espessura/2 + 0.01])
        linear_extrude(height = 0.1)
            desenho_circuito_elaborado();
}

// ===== Módulos de Geometria =====

module curva_vortex_2d() {
    // Seus pontos perfeitos da última versão
    p = [ [7, 3], [10, 8], [16, 14], [23, 16], [29, 14] ];
    largura_canal = 5;
    for (i = [0 : len(p) - 2]) {
        hull() {
            translate(p[i]) circle(d=largura_canal);
            translate(p[i+1]) circle(d=largura_canal);
        }
    }
}

module desenho_circuito_elaborado() {
    // Anel Central
    difference() {
        circle(d=42);
        circle(d=39);
    }

    // Ramos de circuito estilo "Árvore" (idêntico à foto)
    for (i = [0:11]) {
        rotate([0, 0, i * 30]) {
            // Tronco principal do ramo
            hull() {
                translate([21, 0]) circle(d=1);
                translate([32, 0]) circle(d=1);
            }
            // Ramificação 1 (Angulada)
            rotate([0, 0, 20])
            hull() {
                translate([25, 0]) circle(d=0.8);
                translate([30, 3]) circle(d=0.8);
            }
            // Pontas circulares (os "terminais")
            translate([32, 0]) circle(d=2.5);
            rotate([0, 0, 20]) translate([30, 3]) circle(d=2.2);
            
            // Um círculo extra no anel para detalhe
            translate([21, 0]) circle(d=2);
        }
    }
}