.. -*- coding: utf-8 -*-
.. Copyright |copy| 2012, 2020 by `Olivier Bonaventure <http://perso.uclouvain.be/olivier.bonaventure>`_, Etienne Rivière, Christoph Paasch, Grégory Detal
.. Ce fichier est distribué sous une licence `creative commons <http://creativecommons.org/licenses/by-sa/3.0/>`_

.. _shell:

Utilisation d'un système Unix
=============================

Dans cette section, nous allons décrire comment utiliser un système Unix tel que GNU/Linux en mettant l'accent sur l'utilisation de la ligne de commande et l'automatisation de tâches via des *scripts*.

Utilitaires
^^^^^^^^^^^

Unix a été conçu à l'époque des mini-ordinateurs. Un mini-ordinateur servait plusieurs utilisateurs en même temps. Ceux-ci y étaient connectés par l'intermédiaire d'un terminal équipé d'un écran et d'un clavier. Les programmes traitaient les données entrées par l'utilisateur via le clavier ou stockées sur le disque. Les résultats de l'exécution des ces programmes étaient affichés à l'écran, sauvegardés sur disque ou parfois imprimés sur papier.

Unix ayant été initialement développé pour manipuler des documents contenant du texte, il comprend de nombreux utilitaires facilitant ces traitements. Une description de l'ensemble de ces utilitaires sort du cadre de ce cours. De nombreux livres et ressources Internet fournissent une description détaillée. Voici cependant une brève présentation de quelques utilitaires de manipulation de texte qui peuvent s'avérer très utiles en pratique.

 - `cat(1)`_ : utilitaire permettant notamment de lire et afficher le contenu d'un fichier.
 - `echo(1)`_ : utilitaire permettant d'afficher une chaîne de caractères passée en argument.
 - `head(1)`_ et `tail(1)`_ : utilitaires permettant respectivement d'extraire le début ou la fin d'un fichier.
 - `wc(1)`_ : utilitaire permettant de compter le nombre de caractères et de lignes d'un fichier.
 - `grep(1)`_ : utilitaire permettant notamment d'extraire d'un fichier texte les lignes qui contiennent ou ne contiennent pas une chaîne de caractères passée en argument.
 - `sort(1)`_ : utilitaire permettant de trier les lignes d'un fichier texte.
 - `uniq(1)`_ : utilitaire permettant de filtrer le contenu d'un fichier texte afin d'en extraire les lignes qui sont uniques ou dupliquées (cela requiert que le fichier d'entrée soit trié, car cet utilitaire ne compare que les lignes consécutives).
 - `more(1)`_ : utilitaire permettant d'afficher page par page un fichier texte (`less(1)`_  est une variante courante de `more(1)`_).
 - `gzip(1)`_ et `gunzip(1)`_ : utilitaires permettant respectivement de compresser et de décompresser des fichiers. Les fichiers compressés prennent moins de place sur le disque que les fichiers standard et ont par convention un nom qui se termine par ``.gz``.
 - `tar(1)`_ : utilitaire permettant de regrouper plusieurs fichiers dans une archive. Souvent utilisé en combinaison avec `gzip(1)`_ pour réaliser des backups ou distribuer des logiciels.
 - `sed(1)`_ : utilitaire permettant d'éditer, c'est-à-dire de modifier les caractères présents dans un flux de données.
 - `awk(1)`_ : utilitaire incluant un petit langage de programmation et qui permet d'écrire rapidement de nombreux programmes de manipulation de fichiers de texte.

.. topic:: Pages de manuel

  Les systèmes d'exploitation de la famille Unix contiennent un grand nombre de librairies, d'appels systèmes et d'utilitaires. Toutes ces fonctions et tous ces programmes sont documentés dans des pages de manuel qui sont accessibles via la commande ``man``. Les pages de manuel sont organisées en 8 sections.

   - Section 1: Utilitaires disponibles pour tous les utilisateurs
   - Section 2: Appels systèmes en C
   - Section 3: Fonctions de la librairie
   - Section 4: Fichiers spéciaux
   - Section 5: Formats de fichiers et conventions pour certains types de fichiers
   - Section 6: Jeux
   - Section 7: Utilitaires de manipulation de fichiers textes
   - Section 8: Commandes et procédure de gestion du système

  Dans le cadre de ce cours, nous aborderons principalement les fonctionnalités décrites dans les trois premières sections des pages de manuel. L'accès à une page de manuel se fait via la commande ``man`` avec comme argument le nom de la commande concernée. Vous pouvez par exemple obtenir la page de manuel de ``gcc`` en tapant ``man gcc``. ``man`` supporte plusieurs paramètres qui sont décrits dans sa page de manuel accessible via ``man man``. Dans certains cas, il est nécessaire de spécifier la section du manuel demandée. C'est le cas par exemple pour ``printf`` qui existe comme utilitaire (section 1) et comme fonction de la librairie (section 3 - accessible via ``man 3 printf``).

  Outre ces pages de manuel locales, il existe également de nombreux sites web où l'on peut accéder aux pages de manuels de différentes versions de Unix dont notamment :

   - les pages de manuel de `Debian GNU/Linux <http://manpages.debian.net/>`_
   - les pages de manuel de `FreeBSD <http://www.freebsd.org/cgi/man.cgi>`_
   - les pages de manuel de `MacOS <http://developer.apple.com/documentation/Darwin/Reference/ManPages/index.html>`_

  Dans la version en ligne de ces notes, toutes les références vers un programme Unix, un appel système ou une fonction de la librairie pointent vers la page de manuel Linux correspondante.

Shell
^^^^^

Avant le développement des interfaces graphiques telles que :term:`X11`, :term:`Gnome` ou :term:`Aqua`, l'utilisateur interagissait exclusivement avec l'ordinateur par l'intermédiaire d'un interpréteur de commandes. Dans le monde Unix, le terme anglais :term:`shell` est le plus souvent utilisé pour désigner cet interpréteur et nous ferons de même.

Un :term:`shell` est un programme qui a été spécialement conçu pour faciliter l'utilisation d'un système Unix via le clavier. De nombreux shells Unix existent. Les plus simples permettent à l'utilisateur de taper une série de commandes à exécuter en les combinant. Les plus avancés sont des interpréteurs de commandes qui supportent un langage complet permettant le développement de scripts plus ou moins ambitieux. Dans le cadre de ce cours, nous utiliserons `bash(1)`_ qui est un des shells les plus populaires et les plus complets. La plupart des commandes `bash(1)`_ que nous utiliserons sont cependant compatibles avec de nombreux autres shells tels que `zsh <http://www.zsh.org>`_ ou `csh <https://github.com/tcsh-org/tcsh>`_.

Bien que les interfaces graphiques soient désormais généralisées, le shell reste un moyen d'interaction avec le système parfaitement complémentaire, particulièrement utile pour les informaticiens, ou toute personne devant automatiser des traitements et opérations sur un système informatique (comme par exemple un ingénieur en sciences des données). Avec les interfaces graphiques actuelles, le shell est accessible par l'intermédiaire d'une application qui est généralement appelée ``terminal`` ou ``console``.

Lorsqu'un utilisateur se connecte à un système Unix, en direct ou à travers une connexion réseau, le système vérifie son mot de passe puis exécute automatiquement le shell qui est associé à cet utilisateur depuis son répertoire par défaut. Ce shell permet à l'utilisateur d'exécuter et de combiner des commandes. Un shell supporte deux types de commande : les commandes internes qu'il implémente directement et les commandes externes qui font appel à un utilitaire stocké sur disque. Un exemple de commande interne est `cd(1posix)`_ qui prend comme argument un chemin (relatif ou absolu) et y positionne le répertoire courant. Les utilitaires présentés dans la section précédente sont des exemples de commandes externes.

.. .. note:: Obtenir de l'aide sur une commande
..
..  La commande `man(1)`_ permet d'obtenir la documentation associée à une commande externe. Par exemple, `man ls` permet d'obtenir la documentation de la commande `ls` et en particulier de lister les arguments et paramètres reconnus par cette commande.
..
..  **Attention :** `man(1)`_ permet de spécifier dans quel section de la documentation la page de documentation doit être recherchée. Il existe en effet 8 sections. La page de manuel de `man(1)`_ liste ces sections : on l'obtient avec la commande `man man`. Par exemple, `printf` peut référer aussi bien en section (1) à une commande externe qu'en section (3) à la fonction de la librairie standard du langage C. `man printf` présente par défaut la première occurence, celle en section (1). Pour obtenir la documentation de la fonction `printf` de la librairie standard C il faut spécifier la section avec la commande `man 3 printf`.

Voici quelques exemples d'utilisation de commandes externes.

.. literalinclude:: src/exemple.out
        :language: console

.. spelling::

   supercalculateurs
   quadrimestre

Combiner des commandes
^^^^^^^^^^^^^^^^^^^^^^

La plupart des utilitaires fournis avec un système Unix ont été conçus pour être utilisés en combinaison avec d'autres. Cette combinaison efficace de plusieurs petits utilitaires est un des points forts des systèmes Unix par rapport à d'autres systèmes d'exploitation. On peut imaginer par exemple associer `sort(1)`_ et `head(1)`_ pour n'afficher que les premiers noms en ordre alphabétique d'une liste d'étudiants disponible initialement sous forme non triée. Afin de permettre cette combinaison, chaque programme Unix en cours d'exécution (chaque *processus*) est associé à trois *flux* standards :

 - une entrée standard (:term:`stdin` en anglais) qui est un flux d'informations par lequel le processus reçoit les données à traiter. Par défaut, l'entrée standard est associée au clavier.
 - une sortie standard (:term:`stdout` en anglais) qui est un flux d'informations sur lequel le processus écrit le résultat de son traitement. Par défaut, la sortie standard est associée au terminal.
 - une sortie d'erreur standard (:term:`stderr` en anglais) qui est un flux de données sur lequel le processus écrira les messages d'erreur éventuels. Par défaut, la sortie d'erreur standard est associée au même terminal que :term:`stdout`.

La puissance du :term:`shell` vient de la possibilité de combiner des commandes en redirigeant les entrées et sorties standards. Les shells Unix supportent différentes formes de redirection. Tout d'abord, il est possible de forcer un programme à lire son entrée standard depuis un fichier plutôt que depuis le clavier. Cela se fait en ajoutant à la fin de la ligne de commande le caractère ``<`` suivi du nom du fichier à lire. Ensuite, il est aussi possible de rediriger la sortie standard vers un fichier. Cela se fait en utilisant ``>`` ou ``>>``. Lorsqu'une commande est suivie de ``> file``, le fichier ``file`` est créé si il n'existait pas et remis à zéro si il existait, et la sortie standard de cette commande est redirigée vers le fichier ``file``. Enfin, lorsqu'un commande est suivie de ``>> file``, la sortie standard est sauvegardée à la fin du fichier ``file`` (si ``file`` n'existait pas, il est créé).

Voici un exemple d'utilisation des redirections :

.. literalinclude:: src/exemple2.out
        :language: console

.. note:: Rediriger la sortie d'erreur standard

 La redirection `> file` redirige par défaut la sortie standard vers le fichier `file`. La sortie d'erreur standard reste dirigé, quand à elle, vers le terminal de l'utilisateur. Il arrive toutefois que l'on souhaite diriger les messages d'erreur vers un fichier différent. On peut pour cela utiliser la notation `2> file_errors` (le  flux :term:`stdout` est numéroté 1 et le flux :term:`stderr` est numéroté 2; la notation `> file` est implicitement équivalente à `1> file`). 
 
 Si l'on souhaite rediriger à la fois :term:`stdout` et :term:`stderr` vers le même fichier on ne peux pas utiliser `> file 2> file` ! Il faut d'abord rediriger la sortie :term:`stderr` vers :term:`stdout`, puis diriger ce dernier vers le fichier. Le flux :term:`stdout` est noté `&1`, on utilise donc `2>&1 > file`.
  
 Des informations plus complètes sur les mécanismes de redirection de `bash(1)`_ peuvent être obtenues dans le `chapitre 20 <http://tldp.org/LDP/abs/html/io-redirection.html>`_ de [ABS]_.

Les shells Unix supportent un second mécanisme qui est encore plus intéressant pour combiner plusieurs programmes. Il s'agit de la redirection de la sortie standard d'un programme vers l'entrée standard d'un autre sans passer par un fichier intermédiaire. Cela se réalise avec le symbole ``|`` (:term:`pipe` en anglais). L'exemple suivant illustre quelques combinaisons d'utilitaires de manipulation de texte.

.. literalinclude:: src/exemple3.out
        :language: console

Le premier exemple utilise `echo(1)`_ pour générer du texte et le passer directement à `wc(1)`_ qui compte le nombre de caractères. Le deuxième exemple utilise `cat(1)`_ pour afficher sur la sortie standard le contenu d'un fichier. Cette sortie est reliée à `sort(1)`_ qui trie le texte reçu sur son entrée standard en ordre alphabétique croissant. Cette sortie en ordre alphabétique est reliée à `uniq(1)`_ qui la filtre pour en retirer les lignes dupliquées.

Scripts : les bases
^^^^^^^^^^^^^^^^^^^

Tout shell Unix peut également s'utiliser comme un interpréteur de commande qui permet d'interpréter des scripts. Un système Unix peut exécuter deux types de programmes :

 - des programmes exécutables en langage machine. C'est le cas de la plupart des utilitaires dont nous avons parlé jusqu'ici.
 - des programmes écrits dans un langage interprété. C'est le cas des programmes écrits pour le shell, mais également pour d'autres langages interprétés comme python_ ou perl_.

Lors de l'exécution d'un programme, le système d'exploitation reconnaît [#fexecbit]_ si il s'agit d'un programme directement exécutable ou d'un programme interprété en analysant les premiers octets du fichier. Par convention, sous Unix, les deux premiers caractères d'un programme écrit dans un langage qui doit être interprété sont ``#!``. Ils sont suivis par le nom complet de l'interpréteur qui doit être utilisé pour interpréter le programme.

Le programme `bash(1)`_ le plus simple est le suivant :

.. literalinclude:: src/hello.sh
   :language: bash

L'exécution de ce script shell retourne la sortie suivante :

.. literalinclude:: src/hello.sh.out
        :language: console

Par convention en `bash(1)`_, le caractère ``#`` marque le début d'un commentaire en début ou en cours de ligne. Comme tout langage, `bash(1)`_ permet à l'utilisateur de définir des variables. Celles-ci peuvent contenir des chaînes de caractères ou des nombres. Le script ci-dessous utilise deux variables, ``PROG`` et ``COURS`` et les utilise pour afficher un texte avec la commande ``echo``.

.. literalinclude:: src/hellovar.sh
   :language: bash
   
On note dans l'exemple ci-dessus l'utilisation du symbole ``$`` pour référer à la valeur de la variable. Dans la majorité des cas, cette notation suffit. Il y a toutefois une subtilité à laquelle ont doit faire attention : si il y a une ambiguïté possible sur le nom de la variable pour l'interpréteur il convient d'entourer son nom d'accolades ``{ }``. Par exemple, ``milieu = "mi"; echo do$milieuno`` affichera ``do`` seulement car l'interpréteur considère la seconde partie comme la variable ``$milieuno`` non définie et donc égale à la chaîne vide (et cela sans générer de message d'erreur). Avec ``echo do${milieu}no``, par contre, le résultat est celui attendu. On peut aussi choisir d'utiliser les accolades systématiquement pour éviter des bugs silencieux, par définition difficile à détecter et corriger.

Un script `bash(1)`_ peut également prendre des arguments passés en ligne de commande. Par convention, ceux-ci ont comme noms ``$1``, ``$2``, ``$3``, ... Le nombre d'arguments s'obtient avec ``$#`` et la liste complète avec ``$@``. L'exemple ci-dessous illustre l'utilisation de ces arguments.

.. literalinclude:: src/args.sh
   :language: bash

L'exécution de ce script produit la sortie suivante :

.. literalinclude:: src/args.sh.out
        :language: console

Concernant le traitement des arguments par un script bash, il est utile de noter que lorsque l'on appelle un script en redirigeant son entrée ou sa sortie standard, le script n'est pas informé de cette redirection. Ainsi, si l'on exécute le script précédent en faisant ``args.sh arg1 > args.out``, le fichier ``args.out`` contient les lignes suivantes :

.. literalinclude:: src/args.out
        :language: console

Scripts : conditionnelles
^^^^^^^^^^^^^^^^^^^^^^^^^

Un script permet d'utiliser des structures de contrôle comme dans tout langage de programmation.

`bash(1)`_ supporte tout d'abord la construction conditionnelle ``if [ condition ]; then ... fi`` qui permet notamment de comparer les valeurs de variables. `bash(1)`_ définit de nombreuses conditions différentes, dont notamment :

 - ``$i -eq $j`` est vraie lorsque les deux variables ``$i`` et ``$j`` contiennent le même nombre.
 - ``$i -lt $j`` est vraie lorsque la valeur de la variable ``$i`` est numériquement strictement inférieure à celle de la variable ``$j``
 - ``$i -ge $j`` est vraie lorsque la valeur de la variable ``$i`` est numériquement supérieure ou égale à celle de la variable ``$j``
 -  ``$s = $t`` est vraie lorsque la chaîne de caractères contenue dans la variable ``$s`` est égale à celle qui est contenue dans la variable ``$t``
 - ``-z $s`` est vraie lorsque la chaîne de caractères contenue dans la variable ``$s`` est vide

D'autres types de test sont définis dans la page de manuel : `bash(1)`_. Le script ci-dessous fournit un premier exemple d'utilisation de tests avec `bash(1)`_.

.. literalinclude:: src/eq.sh
   :language: bash

Tout d'abord, ce script vérifie qu'il a bien été appelé avec deux arguments. Vérifier qu'un programme reçoit bien les arguments qu'il attend est une règle de bonne pratique qu'il est bon de respecter dès le début. Si le script n'est pas appelé avec le bon nombre d'arguments, un message d'erreur est affiché sur la sortie d'erreur standard et le script se termine avec un code de retour. Ces codes de retour sont importants car ils permettent à un autre programme, par exemple un autre script `bash(1)`_ de vérifier le bon déroulement d'un programme appelé. Le script :download:`src/eq.sh` utilise des appels explicites à `exit(1posix)`_ même si par défaut, un script `bash(1)`_  qui n'en contient pas retourne un code de retour nul à la fin de son exécution.

Un autre exemple d'utilisation des codes de retour est le script :download:`src/wordin.sh` repris ci-dessous qui utilise `grep(1)`_ pour déterminer si un mot passé en argument est présent dans un fichier texte. Pour cela, il exploite la variable spéciale ``$?`` dans laquelle `bash(1)`_ sauve le code de retour du dernier programme exécuté par le script.

.. literalinclude:: src/wordin.sh
   :language: bash

Ce programme utilise le fichier spécial ``/dev/null``. Celui-ci est en pratique l'équivalent d'un trou noir. Il accepte toutes les données en écriture mais celles-ci ne peuvent jamais être relues. ``/dev/null`` est très utile lorsque l'on veut ignorer la sortie d'un programme et éviter qu'elle ne s'affiche sur le terminal. `bash(1)`_ supporte également ``/dev/stdin`` pour représenter l'entrée standard, ``/dev/stdout`` pour la sortie standard et ``/dev/stderr`` pour l'erreur standard.

Les scripts servent souvent à réaliser des opérations sur des fichiers, et il est parfois nécessaire de pouvoir tester si un fichier est présent, n'est pas vide, etc. On peut alors utiliser les conditions suivantes :

 - ``-f file`` est vraie si ``file`` existe et est un fichier;
 - ``-s file`` est vraie si ``file`` n'est pas vide;
 - ``-r file``, ``-w file``, ``-x file`` est vraie si ``file`` peut, respectivement, être *lu*, *écrit* ou *exécuté* par l'utilisateur lançant le script;
 - ``-s file`` est vraie si ``file`` est le nom d'un répertoire.
 
L'exemple ci-dessous illustre l'utilisation des conditions sur les fichiers :

.. literalinclude:: src/exemple_if_files.sh
   :language: bash

On note l'utilisation du combinateur logique de négation ``!`` pour la troisième condition. Deux autres opérateurs logiques sont disponibles : ``-a`` est le ET logique (AND) et le ``-o`` est le OU logique (OR) :

 - ``-a`` renvoie une valeur positive (faux) si au moins une des deux conditions renvoie une valeur positive, et 0 sinon (vrai);
 - ``-o`` renvoie une valeur positive (faux) si les deux conditions renvoient une valeur positive, et 0 sinon (vrai).

La deuxième et la troisième condition de l'exemple ci-dessus peuvent ainsi être combinées de la manière suivante :

.. literalinclude:: src/exemple_if_files_compact.sh
   :language: bash

La structure ``case`` permet de vérifier une entrée contre une série de motifs. Cela est souvent utile, par exemple, pour l'analyse des paramètres fournis à un script (en utilisant ``-`` et ``--``). La description de ``case`` dépasse cependant le cadre de ce cours.

Scripts : boucles
^^^^^^^^^^^^^^^^^

On utilise régulièrement des boucles pour répéter une opération pour plusieurs argument. Voici un exemple d'utilisation de la boucle ``for`` :

.. literalinclude:: src/exemple_for.sh
   :language: bash

.. literalinclude:: src/exemple_for.sh.out
        :language: console

Une utilisation courante de la boucle ``for`` est pour répéter un même traitement sur tous les fichiers présents dans une liste. La boucle est alors un itérateur : pour chaque itération la variable `s` prend une des valeurs des éléments de la liste séparés par des espaces. 

Cet exemple utilise, par ailleurs, une autre construction utile de `bash(1)`_ : les symboles d'apostrophe inversée ` ` . Ceux-ci permettent d'obtenir le résultat (envoyé sur :term:`stdout`) de l'exécution de la commande qu'il englobent. Examinons en détail cette commande. Celle-ci combine en utilisant un :term:`pipe` les commandes `wc(1)`_ et `cut(1)`_. La première permet d'obtenir le nombre de ligne du fichier fourni en paramètre (utilisation de l'option ``-l``). Toutefois, la sortie de la commande contient trop d'information (par exemple, ``wc -l TP1-Hakim.txt`` renvoie ``28 TP1-Hakim.txt``). Afin d'isoler l'information qui nous intéresse, nous utilisons l'utilitaire `cut(1)`_. Celui-ci permet ici de sélectionner quelle colonne conserver, ici la première, lorsque les colonnes sont séparées par des espaces (comme spécifié en utilisant l'option du délimiteur ``-d``).

La boucle ``for`` peut aussi prendre comme entrée (i.e., la liste sur laquelle itérer) une expression utilisant des caractères *joker* ``*`` ou ``?``. `bash(1)`_ transforme alors l'expression en la liste des noms de fichiers et répertoires dans le répertoire courant correspondant à l'expression :

 - ``*`` représente n'importe quelle suite de caractères (y compris la chaîne vide). ``ab*xyz`` correspond à, par exemple, ``abcdxyz``, ``abzyz`` ou ``abcxyz`` mais pas à ``abcdyz``.
 - ``?`` représente un caractère unique inconnu (mais pas la chaîne vide). ``ab?de`` correspond, ainsi, à ``abcde``, ``abXde`` mais pas à ``abde``.
 
Voici un exemple de l'utilisation du caractère ``*``, qui calcule une signature de chaque fichier sous la forme d'un *hash*  `SHA-1 <https://fr.wikipedia.org/wiki/SHA-1>`_ :

.. literalinclude:: src/exemple_for2.sh
   :language: bash

.. literalinclude:: src/exemple_for2.sh.out
        :language: console

`bash(1)`_ permet aussi l'utilisation de boucles ``while`` et ``until`` sur un principe similaire, mais nous ne les couvrirons pas dans ce cours.

De nombreuses références sont disponibles pour aller plus loin dans la maîtrise de `bash(1)`_ [Cooper2011]_.

.. rubric:: Footnotes

.. [#fexecbit] Sous Unix et contrairement à d'autres systèmes d'exploitation, le suffixe d'un nom de fichier ne joue pas de rôle particulier pour indiquer si un fichier contient un programme exécutable ou non. Comme nous le verrons ultérieurement, le système de fichiers Unix contient des bits de permission qui indiquent notamment si un fichier est exécutable ou non.
