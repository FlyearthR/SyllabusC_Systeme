#!/bin/bash
# vérifie si le fichier fourni en entrée contient des données
if [ $# -ne 1 ]; then
    echo "Erreur, un seul argument est nécessaire" > /dev/stderr
    exit 2
fi
if [ -d $1 ]; then
    echo "Erreur, $1 est un répertoire, pas un fichier" > /dev/stderr
    exit 2
fi
if [ ! -f $1 ]; then
    echo "Erreur, $1 n'existe pas" > /dev/stderr
    exit 2
fi
if [ -s $1 ]; then
    echo "Le fichier $1 contient des données" > /dev/stdout
else
    echo "Le fichier $1 ne contient pas de données" > /dev/stdout
fi
