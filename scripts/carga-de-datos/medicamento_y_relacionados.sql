-- Sustancia Activa 1
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (1, 'Ibuprofeno');
-- Sustancia Activa 2
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (2, 'Paracetamol');
-- Sustancia Activa 3
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (3, 'Amoxicilina');
-- Sustancia Activa 4
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (4, 'Loratadina');
-- Sustancia Activa 5
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (5, 'Metformina');
-- Sustancia Activa 6
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (6, 'Omeprazol');
-- Sustancia Activa 7
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (7, 'Atorvastatina');
-- Sustancia Activa 8
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (8, 'Enalapril');
-- Sustancia Activa 9
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (9, 'Ciprofloxacino');
-- Sustancia Activa 10
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (10, 'Amlodipino');
-- Sustancia Activa 11
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (11, 'Diclofenaco');
-- Sustancia Activa 12
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (12, 'Tramadol');
-- Sustancia Activa 13
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (13, 'Losartán');
-- Sustancia Activa 14
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (14, 'Simvastatina');
-- Sustancia Activa 15
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (15, 'Prednisona');
-- Sustancia Activa 16
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (16, 'Citalopram');
-- Sustancia Activa 17
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (17, 'Salbutamol');
-- Sustancia Activa 18
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (18, 'Furosemida');
-- Sustancia Activa 19
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (19, 'Acetaminofén');
-- Sustancia Activa 20
INSERT INTO sustancia_activa (sustancia_activa_id, sustancia) VALUES (20, 'Clonazepam');

-- Medicamento 1
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (1, 1, 'Medicamento para el dolor');
-- Medicamento 2
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (2, 2, 'Antiinflamatorio y analgésico');
-- Medicamento 3
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (3, 3, 'Antibiótico');
-- Medicamento 4
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (4, 4, 'Antihistamínico');
-- Medicamento 5
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (5, 5, 'Tratamiento para diabetes tipo 2');
-- Medicamento 6
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (6, 6, 'Inhibidor de la bomba de protones');
-- Medicamento 7
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (7, 7, 'Tratamiento para colesterol alto');
-- Medicamento 8
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (8, 8, 'Antihipertensivo');
-- Medicamento 9
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (9, 9, 'Antibiótico de amplio espectro');
-- Medicamento 10
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (10, 10, 'Antihipertensivo');
-- Medicamento 11
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (11, 11, 'Anti-inflamatorio');
-- Medicamento 12
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (12, 12, 'Analgésico');
-- Medicamento 13
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (13, 13, 'Tratamiento para hipertensión');
-- Medicamento 14
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (14, 14, 'Estatinas para colesterol');
-- Medicamento 15
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (15, 15, 'Corticosteroide');
-- Medicamento 16
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (16, 16, 'Antidepresivo');
-- Medicamento 17
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (17, 17, 'Broncodilatador');
-- Medicamento 18
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (18, 18, 'Diurético');
-- Medicamento 19
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (19, 19, 'Analgésico y antinflamatorio');
-- Medicamento 20
INSERT INTO medicamento (medicamento_id, sustancia_activa_id, descripcion) VALUES (20, 20, 'Ansiolítico');
-- (Los medicamentos 21 a 50 pueden seguir una estructura similar, con las sustancias activas que ya definimos)

-- Nombre Comercial 1
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (1, 'Medilac', 1);
-- Nombre Comercial 2
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (2, 'Acuprin', 1);
-- Nombre Comercial 3
-- Nombre Comercial 4
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (4, 'Ibucalm', 1);
-- Nombre Comercial 5
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (5, 'Paracetamol Forte', 2);
-- Nombre Comercial 6
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (6, 'Ciproflor', 3);
-- Nombre Comercial 7
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (7, 'LoraFast', 4);
-- Nombre Comercial 8
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (8, 'Diaform', 5);
-- Nombre Comercial 9
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (9, 'Omefit', 6);
-- Nombre Comercial 10
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (10, 'Atovast', 7);
-- Nombre Comercial 11
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (11, 'Cardiopril', 8);
-- Nombre Comercial 12
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (12, 'CiproPlus', 9);
-- Nombre Comercial 13
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (13, 'Amlodil', 10);
-- Nombre Comercial 14
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (14, 'Dicloflex', 11);
-- Nombre Comercial 15
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (15, 'Tramatol', 12);
-- Nombre Comercial 16
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (16, 'Losartan Plus', 13);
-- Nombre Comercial 17
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (17, 'SimvaStat', 14);
-- Nombre Comercial 18
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (18, 'PredniMax', 15);
-- Nombre Comercial 19
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (19, 'CitaRel', 16);
-- Nombre Comercial 20
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (20, 'SalbuMist', 17);
-- Nombre Comercial 21
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (21, 'Furoside', 18);
-- Nombre Comercial 22
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (22, 'Acetaflex', 19);
-- Nombre Comercial 23
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (23, 'Calmzep', 20);
-- Nombre Comercial 24
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (24, 'IbuproX', 1);
-- Nombre Comercial 25
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (25, 'Panadol', 2);
-- Nombre Comercial 26
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (26, 'AmoxiSure', 3);
-- Nombre Comercial 27
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (27, 'LoraQuick', 4);
-- Nombre Comercial 28
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (28, 'Diabex', 5);
-- Nombre Comercial 29
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (29, 'OmepraX', 6);
-- Nombre Comercial 30
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (30, 'AtorCure', 7);
-- Nombre Comercial 31
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (31, 'CardiFix', 8);
-- Nombre Comercial 32
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (32, 'CiproPlus', 9);
-- Nombre Comercial 33
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (33, 'AmloTone', 10);
-- Nombre Comercial 34
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (34, 'Diclophan', 11);
-- Nombre Comercial 35
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (35, 'Tramatron', 12);
-- Nombre Comercial 36
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (36, 'LosarFix', 13);
-- Nombre Comercial 37
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (37, 'SimbaStat', 14);
-- Nombre Comercial 38
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (38, 'PredniCure', 15);
-- Nombre Comercial 39
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (39, 'CitaloFast', 16);
-- Nombre Comercial 40
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (40, 'Salmex', 17);
-- Nombre Comercial 41
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (41, 'FuroCure', 18);
-- Nombre Comercial 42
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (42, 'Acetaprime', 19);
-- Nombre Comercial 43
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (43, 'Calmzen', 20);
-- Nombre Comercial 44
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (44, 'Ibuprofem', 1);
-- Nombre Comercial 45
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (45, 'Paracel', 2);
-- Nombre Comercial 46
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (46, 'Clavox', 3);
-- Nombre Comercial 47
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (47, 'LoraFlu', 4);
-- Nombre Comercial 48
INSERT INTO medicamento_nombre (medicamento_nombre_id, nombre, medicamento_id) VALUES (48, 'Diabexol', 5);


-- Presentación 1
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (1, 20, 'unidades', 12.50, 1);
-- Presentación 2
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (2, 10, 'ml', 15.75, 2);
-- Presentación 3
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (3, 30, 'unidades', 20.00, 3);
-- Presentación 4
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (4, 50, 'g', 30.00, 4);
-- Presentación 5
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (5, 100, 'ml', 35.00, 5);
-- Presentación 6
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (6, 30, 'unidades', 25.50, 6);
-- Presentación 7
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (7, 10, 'ml', 18.00, 7);
-- Presentación 8
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (8, 50, 'unidades', 40.00, 8);
-- Presentación 9
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (9, 30, 'unidades', 23.50, 9);
-- Presentación 10
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (10, 100, 'ml', 35.00, 10);
-- Presentación 11
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (11, 60, 'g', 28.00, 11);
-- Presentación 12
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (12, 20, 'unidades', 15.00, 12);
-- Presentación 13
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (13, 30, 'unidades', 27.80, 13);
-- Presentación 14
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (14, 100, 'ml', 42.00, 14);
-- Presentación 15
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (15, 50, 'unidades', 18.00, 15);
-- Presentación 16
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (16, 10, 'g', 13.00, 16);
-- Presentación 17
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (17, 30, 'ml', 22.50, 17);
-- Presentación 18
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (18, 20, 'unidades', 16.50, 18);
-- Presentación 19
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (19, 100, 'g', 55.00, 19);
-- Presentación 20
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (20, 60, 'unidades', 30.00, 20);
-- Presentación 21
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (21, 10, 'unidades', 15.00, 1);
-- Presentación 22
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (22, 100, 'ml', 40.00, 2);
-- Presentación 23
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (23, 30, 'g', 22.50, 3);
-- Presentación 24
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (24, 20, 'unidades', 18.00, 4);
-- Presentación 25
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (25, 60, 'ml', 30.00, 5);
-- Presentación 26
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (26, 50, 'unidades', 35.00, 6);
-- Presentación 27
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (27, 20, 'g', 14.00, 7);
-- Presentación 28
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (28, 100, 'unidades', 50.00, 8);
-- Presentación 29
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (29, 100, 'ml', 28.00, 9);
-- Presentación 30
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (30, 10, 'g', 12.50, 10);
-- Presentación 31
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (31, 30, 'unidades', 25.00, 11);
-- Presentación 32
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (32, 60, 'ml', 20.00, 12);
-- Presentación 33
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (33, 50, 'unidades', 32.00, 13);
-- Presentación 34
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (34, 100, 'g', 45.00, 14);
-- Presentación 35
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (35, 20, 'unidades', 28.00, 15);
-- Presentación 36
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (36, 30, 'ml', 18.00, 16);
-- Presentación 37
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (37, 10, 'unidades', 22.00, 17);
-- Presentación 38
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (38, 100, 'ml', 38.00, 18);
-- Presentación 39
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (39, 30, 'unidades', 27.00, 19);
-- Presentación 40
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (40, 100, 'ml', 33.00, 20);
-- Presentación 41
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (41, 10, 'g', 21.50, 1);
-- Presentación 42
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (42, 50, 'unidades', 40.00, 2);
-- Presentación 43
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (43, 100, 'ml', 37.00, 3);
-- Presentación 44
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (44, 60, 'unidades', 31.50, 4);
-- Presentación 45
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (45, 30, 'ml', 16.00, 5);
-- Presentación 46
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (46, 10, 'unidades', 10.50, 6);
-- Presentación 47
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (47, 20, 'g', 25.00, 7);
-- Presentación 48
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (48, 50, 'unidades', 34.50, 8);
-- Presentación 49
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (49, 100, 'ml', 29.50, 9);
-- Presentación 50
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (50, 30, 'g', 15.50, 10);
-- Presentación 51
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (51, 10, 'unidades', 18.50, 11);
-- Presentación 52
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (52, 50, 'ml', 39.00, 12);
-- Presentación 53
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (53, 100, 'unidades', 45.00, 13);
-- Presentación 54
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (54, 30, 'ml', 20.00, 14);
-- Presentación 55
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (55, 60, 'g', 12.00, 15);
-- Presentación 56
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (56, 10, 'unidades', 22.00, 16);
-- Presentación 57
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (57, 50, 'ml', 40.00, 17);
-- Presentación 58
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (58, 100, 'g', 24.50, 18);
-- Presentación 59
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (59, 20, 'unidades', 19.00, 19);
-- Presentación 60
INSERT INTO presentacion (presentacion_id, cantidad, unidad, precio, medicamento_id) VALUES (60, 30, 'ml', 25.00, 20);

update presentacion set precio = 20 * precio - 0.01;
