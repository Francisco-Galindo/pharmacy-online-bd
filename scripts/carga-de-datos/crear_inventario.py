#!/usr/bin/env python

import csv
import random

with open('./inventario_farmacia.csv', 'w', newline='') as f:
    fieldnames = ['inventario_farmacia_id', 'num_disponibles', 'farmacia_id', 'presentacion_id']
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()

    i = 1
    for farm in range(11, 26):
        for pres in range(1, 61):
            num = random.randint(0,250)
            if random.random() > 0.8:
                num = 0
            row = {
                    'inventario_farmacia_id': i,
                    'num_disponibles': num,
                    'farmacia_id': farm,
                    'presentacion_id': pres
                    }
            writer.writerow(row)
            i += 1
