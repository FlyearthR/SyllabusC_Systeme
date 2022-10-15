.. -*- coding: utf-8 -*-
.. Copyright |copy| 2020 by Etienne Rivière
.. Ce fichier est distribué sous une licence `creative commons <http://creativecommons.org/licenses/by-sa/3.0/>`_

   
.. _declarations:
 
Structure du système d'exploitation
===================================

L'objectif de ce chapitre est de présenter les grands principes de mise en œuvre d'un système d'exploitation (SE), que nous avons déjà survolé dans le chapitre d'introduction.
On commencera par présenter les différents types de services fournis par un système d'exploitation, pour ensuite détailler l'interface offerte par le noyau aux programmes et aux librairies œuvrant en espace utilisateur.
Cette interface est composée d'*appels systèmes* : nous en nous étudierons la mise en œuvre et l'utilisation.
Nous verrons ensuite différentes manières de structurer logiquement le :term:`noyau` du système d'exploitation, et discuterons des avantages et inconvénients associés aux différentes approches.
Nous aborderons enfin le processus de démarrage du SE.

Services
--------

Le but du système d'exploitation est de rendre des services aux applications, aux développeurs et aux utilisateurs.
Ces services permettent d'exploiter les ressources matérielles de manière simple au travers d'abstractions, mettant en œuvre la virtualisation des ressources comme nous l'avons vu dans notre introduction.

Services aux utilisateurs
^^^^^^^^^^^^^^^^^^^^^^^^^

Une première catégorie de service est l'*interface* apportée aux utilisateurs.
Nous avons déjà étudié le principe de la ligne de commande.
De nombreux systèmes proposent une interface utilisateur graphique, comme vous pouvez l'utiliser tous les jours avec un système comme Windows ou Mac OS, ou en utilisant l'un des nombreux gestionnaires de fenêtres disponibles dans les distributions GNU/Linux, comme Gnome ou KDE.

Un troisième type d'interface existe : il s'agit de l'accès en mode *batch* (ou en mode de  *traitement par lot* en français).
Avec une telle interface, l'utilisateur n'utilise pas le système de manière interactive.
À la place, les demandes d'exécution de programmes (incluant le nom du programme, ses arguments, et les données à traiter) sont envoyées à un gestionnaire de traitement par lot, qui se chargera de l'exécuter plus tard, typiquement lorsque les ressources matérielles nécessaires seront disponibles et en suivant généralement une politique FIFO (premier-arrivé, premier-servi) ou par priorités.

Les interfaces de traitement par lots étaient courantes sur les premiers ordinateurs ne mettant pas en œuvre le principe de temps partagé.
L'entrée du programme et de ses données se faisant en effet manuellement.
Le rôle du gestionnaire de traitement par lot était alors tenu par un humain.
Ce mode d'utilisation reste de nos jours très utilisé dans les centres de calcul à haute performance, par exemple pour réaliser des simulations de processus physiques ou biologiques.

.. note:: Planifier l'exécution de programmes dans un système interactifs

 Lorsque l'utilisateur envoie une commande au :term:`shell`, le programme correspondant est exécuté immédiatement, contrairement au mode de traitement par lot.
 Il peut être parfois nécessaire de prévoir à l'avance l'exécution d'une commande, ou bien de réaliser cette exécution de façon périodique.
 Par exemple, l'exécution d'un utilitaire préparant un rapport sur l'utilisation des ressources du système peut être déclenché chaque nuit et pourra envoyer un message à l'administrateur si un quota d'utilisation est dépassé.
 
 La commande `crontab(1)`_ permet de planifier l'exécution périodique d'une commande.
 La commande `at(1posix)`_ permet quand à elle de demander l'exécution d'une commande à un temps absolu ou relatif, donné, comme dans l'exemple qui suit.
 
 .. code-block:: bash
 
    at -m 0730 tomorrow
    sort < file > outfile
    EOT

Services aux concepteurs d'applications
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Le système d'exploitation fournit par ailleurs des services aux développeurs d'applications.
Ces services permettent de faciliter le développement et l'amélioration des applications (et en particulier, de leur fiabilité et de leur performance).

Le système d'exploitation fournit tout d'abord des services permettant de faciliter l'assemblage et le chargement d'un programme en mémoire.
Un premier utilitaire appelé le *linker* permet d'assembler les fichiers objets générés par le compilateur ainsi que les librairies statiques afin d'obtenir un programme exécutable.
Les principes du *linker* sont couverts dans la partie du syllabus traitant des grands programmes en C.
Le programme `ld(1)`_ joue ce rôle sous GNU/Linux.
Un deuxième utilitaire est nécessaire lors de l'exécution du programme : le *loader*.
Il réalise deux opérations : (1) la mise en place de l'espace mémoire du programme, la réservation des segments, et leur remplissage à partir du fichier exécutable et (2) le chargement dans cet espace mémoire des librairies dynamiques.
Le loader sous GNU/Linux est une combinaison de fonctions réalisées par le :term:`noyau` (pour la création de l'espace mémoire virtuel principalement) et par la librairie `ld.so(8)`_.
Le loader pré-assigne les différentes sections de l'espace mémoire à partir du fichier programme (section text et sections de données initialisées et non initialisées), prépare le contenu de la section des variables d'environnement, et effectue le chargement des librairies dynamiques.
À la fin de l'exécution, les ressources utilisées par le processus sont libérées et le système d'exploitation gère la récupération du code de retour du programme.

Lorsqu'un processus est en cours d'exécution, le système d'exploitation peut permettre d'observer voire de contrôler celui-ci pour permettre la compréhension de son comportement et pour faciliter sa mise au point.

Tout d'abord, une erreur peut survenir lors de l'exécution du programme.
Le système d'exploitation permet alors de récupérer des informations sur l'erreur elle-même, ainsi qu'à propos de son contexte d'apparition (comme, par exemple, l'ensemble du contenu de la mémoire au moment de son occurence).
Des exemples d'erreurs classiques sont listées ci-dessous.

- L'accès à un segment de mémoire non autorisé, si par exemple le programme essaie de lire une adresse au dessus de la limite du stack (et donc avant que celle-ci ne soit étendue avec un appel à `sbrk(2)`_), ou bien essaie de lire une adresse d'un des segments réservés du système d'exploitation au début ou à la fin de l'espace mémoire du processus, ou encore essaie d'*écrire* à une des adresses du :term:`segment text`. 
- L'utilisation d'une opération arithmétique non supportée, comme par exemple une division par 0.
- L'utilisation en mode utilisateur d'une instruction autorisée seulement en mode protégé.

Enfin, le système d'exploitation fournit des services facilitant le déboguage des applications, au delà de la simple récolte d'information lors de l'occurence d'erreurs.
Un déboggueur comme `gdb(1)`_ permet ainsi d'observer l'exécution d'un processus, de la stopper lorsqu'une adresse d'instruction spécifique est atteinte (on parle de point d'arrêt ou *breakpoint* en anglais) ou même d'exécuter les instructions pas à pas (une par une).
Le déboggueur est un processus comme un autre.
Il est donc isolé des autres processus.
Il a pour cette raison besoin de services spécifiques fournis par le :term:`noyau` du système d'exploitation, pour pouvoir inspecter ou modifier l'espace mémoire du processus observé.
Un exemple de service nécessaire est de pouvoir faire la demande au processeur qu'une interruption logicielle (:term:`trap`) soit générée automatiquement lors de l'atteinte d'un point d'arrêt (i.e., l'adresse d'une instruction spécifique dans le segment text) ou même après chaque instruction.
La configuration du processeur à ces fins est une opération qui requiert l'utilisation d'instructions seulement autorisées en mode protégé.

Services aux applications
^^^^^^^^^^^^^^^^^^^^^^^^^

Le système d'exploitation fournit des services aux applications en leur permettant d'exploiter de façon efficace, aisée et portable les ressources matérielles.
Nous avons abordé dans l'introduction les ressources virtualisées fondamentales que sont la notion de processus ou la notion de mémoire virtuelle.
Nous survolons ici des exemples d'autres services.
Nous verrons la mise en œuvre des plus importants d'entre eux plus tard dans ce cours.

Le système d'exploitation fournit pour commencer des services pour permettre l'utilisation d'*entrées/sorties*.
Comme nous l'avons vu en introduction, les gestionnaires de périphériques (connectés à un bus d'entrée/sortie) génèrent des interruptions permettant de prévenir le processeur de la disponibilité de données à traiter.
De la même manière, le processeur peut envoyer des commandes au gestionnaire de périphérique pour initier une opération d'entrée sortie.
Il n'est bien évidemment pas souhaitable de laisser les applications gérer ces opérations elles-même.
Les instructions correspondantes sont ainsi réservées au mode protégé du processeur.
Le système d'exploitation fournit donc des services d'entrée/sortie dont la spécification et l'interface dépend de la nature du système d'entrée/sortie considéré (adaptateur réseau, adaptateur graphique, etc.).
Ces services sont fournis via des abstractions facilement manipulables par un programmeur.

.. note:: Les drivers de périphériques

 Bien que le système d'exploitation fournisse aux applications une abstraction unique pour une même classe de périphériques, ces périphériques sont de mise en œuvre matérielle variées et ne répondent pas toujours au même jeu de commandes, même lorsqu'ils ont le même objectif.
 Par exemple, un adaptateur réseau d'une marque ou d'une génération donnée pourra répondre à des commandes de contrôle qu'un autre adaptateur réseau ne supportera pas.
 Pour pallier cette hétérogénéité, le :term:`noyau` du système d'exploitation utilise des *drivers de périphériques*.
 Ces modules logiciel de très bas niveau reçoivent des commandes d'entrée/sortie génériques en entrée, et les traduisent en des commandes spécifiques à un matériel donné.
 Ils sont le plus souvent développés par l'entreprise fabriquant ce matériel, et leur mise en œuvre nécessite souvent l'utilisation du langage d'assemblage.

Partage de ressources
^^^^^^^^^^^^^^^^^^^^^

Les services fournis aux applications, aux développeurs et aux utilisateurs permettent l'utilisation simplifiée mais aussi *mutualisée* des resources matérielles.
Plusieurs utilisateurs peuvent ainsi utiliser le même système simultanément et chaque utilisateur peut utiliser plusieurs applications.
Un rôle majeur du système d'exploitation dans ce contexte est la mise en œuvre du partage des resources, en visant plusieurs objectifs :

- On souhaite que les ressources soient utilisées de façon efficace afin de maximiser l'utilité du système. Par exemple, il n'est pas toujours souhaitable qu'un processus en attente de la fin d'une opération d'entrée/sortie occupe le processeur à exécuter une boucle d'attente active (i.e., une boucle ``while`` vérifiant de façon répétée qu'une donnée soit disponible pour être consommée, et ce jusqu'à ce soit le cas).
- Les resources partagées doivent l'être de manière équitable, ou tout au moins qui suive les règles de priorité qui ont été choisies pour ce système. 
- Enfin, il est nécessaire d'isoler l'accès aux ressources utilisées par un processus et/ou un utilisateur de l'accès aux autres ressources.

Ce partage nécessite donc des services spécifiques permettant :

- L'allocation des ressources. Certaines ressources peuvent être disponibles de manière exclusive (par exemple, les entrées au clavier ne doivent être visibles que par un seul processus) ou de manière partagée (par exemple, l'adaptateur réseau reçoit et envoie des données pour plusieurs processus).
- Le contrôle d'usage, afin de savoir quel processus et/ou quel utilisateur utilise quelle quantité de ressources.
- La protection d'accès, afin de contrôler si un programme ou un utilisateur a l'autorisation ou non d'utiliser une ressource.

Appels systèmes
---------------

.. index:: kernel

Outre l'utilisation de fonctions de librairies, les programmes doivent donc interagir avec le système d'exploitation afin d'utiliser les services que celui ci fournit.

Un système d'exploitation comme Unix comprend à la fois des utilitaires comme `grep(1)`_, `ls(1)`_, ... qui sont directement exécutables depuis le shell et un noyau ou :term:`kernel` en anglais.
Le :term:`kernel` contient les fonctions de base du système d'exploitation qui lui permettent à la fois d'interagir avec le matériel mais aussi de gérer les processus des utilisateurs. 
En pratique, le kernel peut être vu comme étant un programme spécial qui est toujours présent en mémoire. 
Parmi l'ensemble des fonctions contenues dans le :term:`kernel`, il y en a un petit nombre, typiquement de quelques dizaines à quelques centaines, qui sont utilisables par les processus lancés par les utilisateurs. 
Un :term:`appel système` est une fonction du :term:`kernel` qui peut être appelée par n'importe quel processus.
Comme nous l'avons vu lorsque nous avons décrit le fonctionnement du langage d'assemblage, l'exécution d'une fonction dans un processus comprend plusieurs étapes :

 1. Placer les arguments de la fonction à un endroit (la pile) où la fonction peut y accéder
 2. Sauvegarder sur la pile l'adresse de retour
 3. Modifier le registre ``%eip`` de façon à ce que la prochaine instruction à exécuter soit celle de la fonction à exécuter
 4. La fonction récupère ses arguments (sur la pile) et réalise son calcul
 5. La fonction sauve son résultat à un endroit convenu avec la fonction appelante (comme le registre ``%eax`` pour le jeu d'instructions IA32)
 6. La fonction récupère l'adresse de retour sur la pile et modifie ``%eip`` de façon à retourner à la fonction appelante

L'exécution d'un appel système comprend les mêmes étapes mais avec une différence importante qui est que le flux d'exécution des instructions doit passer du programme utilisateur au noyau du système d'exploitation. Pour comprendre le fonctionnement et l'exécution d'un appel système, il est utile d'analyser les six points mentionnés ci-dessus.

Le premier problème à résoudre pour exécuter un appel système est de pouvoir placer les arguments de l'appel système dans un endroit auquel le :term:`kernel` pourra facilement accéder. Il existe de nombreux appels systèmes avec différents arguments. La liste complète des appels systèmes est reprise dans la page de manuel `syscalls(2)`_. La table ci-dessous illustre quelques appels systèmes et leurs arguments.

==============            =====================
Appel système             Arguments
==============            =====================
`getpid(2)`_              ``void``
`fork(2)`_                ``void``
`read(2)`_                ``int fildes, void *buf, size_t nbyte``
`kill(2)`_                ``pid_t pid, int sig``
`brk(2)`_                 ``const void *addr``
==============            =====================

Sous Linux, les arguments d'un appel système sont placés par convention dans des registres. Sur [IA32]_, le premier argument est placé dans le registre ``%ebx``, le second dans ``%ecx``, ... Le :term:`kernel` peut donc facilement récupérer les arguments d'un appel système en lisant le contenu des registres.

Le second problème à résoudre est celui de l'adresse de retour. Celle-ci est automatiquement sauvegardée lors de l'exécution de l'instruction qui fait appel au kernel, tout comme l'instruction ``calll`` sauvegarde directement l'adresse de retour d'une fonction appelée sur la pile.

.. index:: mode utilisateur, mode protégé

Le troisième problème à résoudre est de passer de l'exécution du processus utilisateur à l'exécution du :term:`kernel`.
Comme abordé dans l'introduction, les processeurs actuels peuvent fonctionner dans au minimum deux modes : le :term:`mode utilisateur` et le :term:`mode protégé`.
Lorsque le processeur fonctionne en mode protégé, toutes les instructions du processeur et toutes les adresses mémoire sont utilisables.
Lorsqu'il fonctionne en mode utilisateur, quelques instructions spécifiques de manipulation du matériel et certaines adresses mémoire ne sont pas utilisables.
Cette division en deux modes de fonctionnement permet d'avoir une séparation claire entre le système d'exploitation et les processus lancés par les utilisateurs.
Le noyau du système d'exploitation s'exécute en mode protégé et peut donc utiliser entièrement le processeur et donc contrôler sans limites les dispositifs matériels de l'ordinateur.
Les processus utilisateurs, en revanche, sont exécutés en mode utilisateur.
Ils ne peuvent donc pas directement exécuter les instructions permettant une interaction avec des dispositifs matériels.
Cette interaction doit passer par le noyau du système d'exploitation qui sert de médiateur et vérifie la validité des demandes faites par un processus utilisateur.

.. index:: init

Les transitions entre les modes protégé et utilisateur sont importantes car elles rythment le fonctionnement du système d'exploitation. Lorsque l'ordinateur démarre, le processeur est placé en mode protégé et le :term:`kernel` se charge. Il initialise différentes structures de données et lance `init(8)`_ le premier processus du système. Dès que `init(8)`_ a été lancé, le processeur passe en mode utilisateur et exécute les instructions de ce processus. Après cette phase de démarrage, des instructions du :term:`kernel` seront exécutées lorsque soit une interruption matérielle surviendra ou qu'un processus utilisateur exécutera un appel système. L'interruption matérielle place automatiquement le processeur en mode protégé et le :term:`kernel` exécute la routine de traitement d'interruption correspondant à l'interruption qui est apparue. Un appel système démarre par l'exécution d'une instruction spéciale (parfois appelée interruption logicielle) qui place le processeur en mode protégé puis démarre l'exécution d'une instruction placée à une adresse spéciale en mémoire. Sur certains processeurs de la famille [IA32]_, l'instruction ``int 0x80`` permet ce passage du mode utilisateur au mode protégé. Sur d'autres processeurs, c'est l'instruction ``syscall`` qui joue ce rôle. L'exécution de cette instruction est la seule possibilité pour un programme d'exécuter des instructions du :term:`kernel`. En pratique, cette instruction fait passer le processeur en mode protégé et démarre l'exécution d'une routine spécifique du :term:`kernel` et qui en est l'unique point d'entrée. Cette routine commence par sauvegarder le contexte du processus qui exécute l'appel système demandé. Chaque appel système est identifié par un nombre entier. Le :term:`kernel` contient une table avec, pour chaque appel système, l'adresse de la fonction à exécuter. En pratique, le numéro de l'appel système à exécuter est placé par le processus appelant dans le registre ``%eax``.

L'appel système peut donc s'exécuter en utilisant les arguments qui se trouvent dans les différents registres. Lorsque l'appel système se termine, le résultat est placé dans le registre ``%eax`` et une instruction spéciale permet de retourner en mode utilisateur et d'exécuter dans le processus appelant l'instruction qui suit celle qui a provoqué l'exécution de l'appel système. Si l'appel système a échoué, le :term:`kernel` doit aussi mettre à jour le contenu de ``errno`` avant de retourner au processus appelant.

Ces opérations sont importantes pour comprendre le fonctionnement d'un système informatique et la différence entre un appel système et une fonction de la librairie. En pratique, la librairie cache cette complexité au programmeur en lui permettant d'utiliser des fonctions de plus haut niveau [#fsyscall]_ . Cependant, il faut être conscient que ces fonctions s'appuient elles-même sur des appels systèmes pour s'exécuter. Ainsi par exemple, la fonction `printf(3)`_ utilise l'appel système `write(2)`_ pour écrire sur la sortie standard. La commande `strace(1)`_ permet de tracer l'ensemble des appels systèmes faits par un processus. A titre d'exemple, voici les appels systèmes effectués par le programme "Hello world" du début de la présentation du langage C, et repris ci-dessous.

.. code-block:: c

   #include <stdio.h>
   #include <stdlib.h>

   int main(int argc, char *argv[])
   {
      printf("Hello, world! %d\n",sizeof(int));

      return EXIT_SUCCESS;
   }

.. code-block:: console

 $ strace ./helloworld_s
 execve("./helloworld_s", ["./helloworld_s"], [/* 21 vars */]) = 0
 uname({sys="Linux", node="precise32", ...}) = 0
 brk(0)                                  = 0x9e8b000
 brk(0x9e8bd40)                          = 0x9e8bd40
 set_thread_area({entry_number:-1 -> 6, base_addr:0x9e8b840, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
 brk(0x9eacd40)                          = 0x9eacd40
 brk(0x9ead000)                          = 0x9ead000
 fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb778a000
 write(1, "Hello, world! 4\n", 16Hello, world! 4
 )       = 16
 exit_group(0)                           = ?

Il n'est pas nécessairement utile de comprendre l'intégralité de ces lignes, mais on peut y déceler les points d'intérêt suivants : 

- Le premier appel système `execve(2)`_ prend comme argument le programme à exécuter ;
- Les appels système `brk(2)`_, `set_thread_area(2)`_ ou `mmap2(2)`_ sont utilisés par le chargeur de programme (*loader*) pour mettre en place l'espace mémoire du processus ;
- Enfin, l'appel `write(2)`_ est utilisé pour envoyer vers :term:`STDOUT` la chaîne de caractères formatée par la fonction correspondante de la librairie standard, `printf(3)`_.

Si, dans cet exemple, on voit une correspondance assez directe entre une fonction de la librairie standard (`printf(3)`_) et un appel système, certaines fonctions de la librairie, ou bien certains utilitaires, utilisent de très nombreux appels systèmes pour réaliser leur fonction.
Pour reprendre l'exemple cité précédemment du débogueur gdb, celui-ci va effectuer de nombreux appels systèmes au services du :term:`noyau` permettant le contrôle d'un processus en cours d'exécution, en en particulier l'appel `ptrace(2)`_.

Architecture logicielle des systèmes d'exploitation
===================================================

Nous avons vu que l'interface entre les programmes en mode utilisateur (y compris les programmes utilitaires du système d'exploitation) et le noyau de ce système d'exploitation, utilise le principe d'appel système.
Nous avons par ailleurs vu que les gestionnaires de périphériques, au plus bas niveau, utilisent des composants logiciels spécifiques au matériel utilisé, les drivers de périphériques.

Nous allons nous intéresser dans cette section à la mise en œuvre du noyau lui-même et de ses fonctions associées.
Il n'existe pas d'approche universelle et idéale *dans tous les cas* pour structurer un système d'exploitation.
Le choix d'une architecture logicielle spécifique est dictée par plusieurs contraintes, dont certaines peuvent être contradictoires :

- Des contraintes matérielles, et en particulier le support par le processeur de mécanismes efficaces permettant des abstractions de haut niveau (comme la mémoire virtuelle) ou le support de l'isolation entre programmes (par exemple l'existence de modes protégé/utilisateur).
- De la performance et du coût à l'exécution des services systèmes.
- De la consommation de ressources du système, en particulier en termes d'occupation mémoire.
- De la facilité d'évolution du système d'exploitation par l'ajout de nouvelles fonctionnalités, le support de nouveau matériel, ou sa capacité à être adapté à des contextes d'utilisation différents.
- De sa fiabilité et de la facilité de sa maintenance et de son déboguage.

Nous allons illustrer quelques unes des possibilités en utilisant quelques exemples.

Un système simple : MS-DOS
--------------------------

MS-DOS a été dans les années 1980 et a été pendant une bonne partie des années 1990 le système d'exploitation principalement utilisé pour les ordinateurs de type IBM-PC et compatibles.
Ce système d'exploitation ne fait pas partie de la famille UNIX.

Le système MS-DOS visait une utilisation mono-utilisateur et mono-application.
Il ne met donc pas en œuvre le concept de temps partagé, et n'a donc pas besoin de supporter une isolation forte entre plusieurs applications ou même entre les applications et le noyau.
Les processeurs supportés par le système MS-DOS, du type Intel 8086 et compatibles (80286, 80386, 80486) n'offraient de toutes façons pas toujours un support complet pour l'isolation entre un mode d'exécution protégé pour le noyau et un mode utilisateur.
En revanche, le matériel visé avait des contraintes très fortes en termes de mémoire disponible : le système d'exploitation doit donc tenir dans le moins d'instructions possibles pour réserver le reste de la mémoire pour les applications.

Le système MS-DOS original a donc été mis en œuvre de façon monolithique, sans séparation claire des fonctionnalités et services, et sans support réel pour la modularité.
Le processus unique de l'application, ainsi que le code du noyau, résident dans le même espace mémoire.
L'utilisation des appels systèmes utilise le principe d'interruption avec le passage des arguments dans les registres mais l'isolation entre la mémoire de l'application et celle du noyau n'est pas assurée (par exemple, l'application peut lire les structures de données manipulées par le noyau).
Les applications peuvent, par ailleurs, accéder directement aux gestionnaires de périphériques.

.. note:: Quand un système simple et concis devient la base d'une industrie

 Le système MS-DOS a été originalement conçu pour des ordinateurs aux capacités très limités au début des années 1980.
 On comprend, dès lors, la volonté de rendre le code le plus petit et le plus simple possible.
 MS-DOS est un bon exemple de logiciel qui n'a pas été pensé à la base pour être étendu et adapté à des ordinateurs plus complexes ou avec plus de ressources, mais qui a eu une durée de vie importante pour des raisons commerciales et ce bien au delà des intentions initiales.
 Ce manque de structuration et d'isolation originel a eu des conséquences importantes sur la complexité et l'évolution des systèmes informatiques de type PC.
 Par exemple, lors de la conception de MS-DOS, l'espace mémoire disponible a été fixé à une capacité maximale de 640 Kilo-octets.
 L'utilisation de mémoire supplémentaire a été rendu possible par la suite grâce à un mécanisme dit de *mémoire étendue* dont l'utilisation n'est pas transparente pour l'application, ce qui rend la programmation inutilement complexe.
 L'absence d'une structure claire et de propriétés d'isolation a aussi été la source d'un grand nombre de vulnérabilités et de problèmes de sécurité dans MS-DOS et les systèmes s'y appuyant, comme les premiers systèmes Microsoft Windows.

Les systèmes monolithiques multi-utilisateurs : UNIX
----------------------------------------------------

Les premières version du système d'exploitation UNIX visaient une utilisation en partage de temps entre plusieurs applications et plusieurs utilisateurs.
Le support pour l'isolation entre les applications (les processus) était donc primordial.
Le matériel visé par ce système supportait déjà matériellement cette isolation, avec les deux modes d'exécution utilisateur et protégé.
Contrairement à MS-DOS, l'interface entre les applications et le :term:`noyau` était clairement définie.
L'interface entre le :term:`noyau` et le matériel s'appuie sur un ensemble de drivers de périphériques.

L'organisation du noyau des UNIX originels était ce qu'on appelle une architecture *monolithique*.
L'ensemble des fonctionnalités du système était assuré par un module logiciel unique, mettant en œuvre l'ensemble des appels système, de la même façon que pour le système MS-DOS.
Très rapidement, cette structure à un seul niveau s'est révélée complexe à maintenir et à faire évoluer, en particulier lorsque ces systèmes UNIX devaient être adaptés pour fonctionner sur de nouveaux modèles de mini-ordinateurs ou sur de nouveaux processeurs.
Il est donc apparu rapidement nécessaire de rendre l'organisation du système d'exploitation plus *modulaire*, c'est à dire de permettre la mise à jour ou l'évolution de différents services de manière séparée.
Une modification du code de l'un de ces services ne doit, en principe, pas entraîner de changements majeurs dans les autres parties du système d'exploitation. 

Structure en couches (UNIX)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Une première approche est d'organiser le système en couches : les services mis en œuvre par une couche dépendent alors uniquement des services fournis par les couches inférieures.
La couche la plus basse est celle qui héberge les drivers de périphérique, et la couche la plus haute est celle qui met en œuvre la réponse aux appels systèmes.
Les couches intermédiaires proposent aux couches supérieures des niveaux d'abstraction des ressources de plus en plus élevés, jusqu'à arriver au niveau d'abstraction fourni à l'espace utilisateur.
Considérons un exemple simplifié d'un service de gestion de périphérique de stockage sur disque dur :

- La couche la plus basse (niveau 0) contient le driver de périphérique, qui est capable de transformer des requêtes pour des blocs de données en des commandes bas niveau pour actionner le bras de lecture du disque, lire une piste magnétique spécifique, etc.
- La couche suivante (niveau 1) construit une abstraction de volumes de données, correspondant aux disques virtuels (volumes), mais n'ayant pas connaissance de la notion de fichiers ou de répertoires.
- Enfin, la dernière couche (niveau 2) met en œuvre l'abstraction d'un système de fichier à proprement parler, en établissant une correspondance entre les blocs de données et les notions de haut-niveau que sont les fichiers et les répertoires.

Une architecture en couche présente des avantages.
Il est plus facile d'isoler les différentes fonctionnalités et de porter le système d'exploitation d'un environnement à un autre.
Par exemple, l'utilisation d'un disque de type SSD ne demandera des changements qu'au niveau 0, et l'utilisation d'un disque distant (accédé par l'intermédiaire d'un réseau) ne demandera des changements qu'au niveau 1.
Dans les deux cas, il ne sera pas nécessaire de modifier le code au niveau 2.
La recherche de bugs sera aussi facilitée : on peut tester les fonctionnalités de la couche N avant de mettre en œuvre les fonctionnalités de la couche N+1.

Toutefois, cette architecture en couche présente aussi deux inconvénients.
Le premier est que le service des appels systèmes doivent désormais utiliser une succession d'appels entre les couches.
Chaque couche va devoir traiter un appel, mettre à jour des structures de données, et préparer un ou plusieurs appels pour les couches inférieures, ce qui peut introduire un surcoût à l'exécution par rapport à une approche monolithique.
Cet inconvénient est relativement limité sur un système moderne où l'exécution du code n'est pas le facteur limitant, mais plutôt l'accès à la mémoire.
La deuxième inconvénient est qu'il n'est pas aisé de structurer clairement un :term:`noyau` de système d'exploitation de cette façon, car les services systèmes sont souvent interdépendants. 
Nous verrons par exemple que la gestion de la mémoire, la gestion des entrées/sorties, ou encore la gestion des processus, dépendent chacun les uns des autres pour assurer leurs fonctionnalités ou pour mettre en œuvre des optimisations.
Pour cette raison, les systèmes modernes comme Linux utilisent peu de couches mais préfèrent une organisation sous forme de modules, comme nous allons le voir à présent.

Structure en modules (Linux)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La structuration en modules combine un cœur du système d'exploitation contenant les services fondamentaux du système (gestion des processus, gestion de la mémoire virtuelle) avec un certain nombre de modules mettant en œuvre les autres fonctionnalités.
Cette stratégie est désormais la plus communément utilisée, par exemple par Linux, Solaris, ou par les versions récentes de Windows.

Les modules peuvent être chargés dynamiquement dans l'espace mémoire du noyau, en fonction des besoins du système informatique considéré, ou lors du démarrage du système.
Prenons comme premier exemple un module permettant l'utilisation d'une interface de périphérique sans fil Bluetooth.
Ce module n'a besoin d'être chargé que sur un système disposant d'un contrôleur de périphérique pour cette technologie.
Un second exemple est le support d'un système de fichier spécifique.
Différents systèmes d'exploitation utilisent généralement des systèmes de fichiers différents (i.e., la manière de représenter les informations des fichiers et des répertoires sur le disque n'est pas la même).
Par exemple, si Linux est installé en *dual-boot* sur un ordinateur contenant aussi une copie de Windows, il sera possible d'accéder au contenu du disque Windows à partir de Linux en chargeant dans le noyau un module spécifique nommé ``exFAT``.
Enfin, si un étudiant utilise un système Linux installé dans une machine virtuelle, par exemple avec Virtual Box, il est possible d'installer des modules spécifiques dans le noyau de la machine virtuelle pour mettre en œuvre des interactions et interopérabilité avec le système hôte (par exemple, permettre le copier/coller d'un système à l'autre).

La structuration en modules présente des avantages similaires à celle de la structuration en couches.
Il est plus facile de déboguer un module dont l'interface est bien définie, que lorsque les fonctionnalités sont noyées dans un grand monolithe.
La séparation en modules facilite l'évolution du système d'exploitation dans le temps et sa portabilité sur des systèmes très différents.
Celle-ci explique en partie pourquoi le noyau Linux est utilisé sur des ordinateurs aussi variés qu'un smartphone Android, une télévision connectée, un ordinateur personnel, ou un super-calculateur regroupant des centaines de milliers de processeurs.
Enfin, l'utilisation de modules résout le problème de l'interdépendance entre couches : les modules peuvent appeler les fonctionnalités des uns des autres sans remettre en question la séparation du code et des données correspondant aux différentes fonctionnalités.

.. note:: Utilisation des modules sous Linux

 Sous Linux, des utilitaires systèmes permettent de charger et décharger des modules dans le noyau.
 Puisque ces modules vont devenir partie du code du noyau, ces opérations sont réservées aux utilisateurs avec un niveau de privilège élevé dans le système, typiquement les administrateurs.
 Ceux-ci peuvent par ailleurs mettre en place le chargement automatique de modules.
 Par exemple, le module `exFAT` pourrait n'être chargé automatiquement que lorsqu'une clé USB à ce format, en provenance d'un ordinateur Windows, est inséré dans un des ports USB de la machine.
 
 La commande ``sudo lsmod`` permet de lister les modules présents.
 On voit un court extrait d'une sortie de cette commande ci-dessous.
 Le module ``psmouse`` permet la gestion des entrées/sorties avec une souris ou un trackpad.
 Les modules ``soundcore`` et ``snd`` sont dédiés à la gestion des entrées/sorties son.
 On peut voir qu'ils peuvent avoir des dépendances : le chargement du module ``snd`` est nécessaire pour charger les modules ``snd_intel8x0``, ``snd_ac97_codec``, ``snd_pcm``, et ``snd_timer``.
 
 .. code-block:: console

  $ sudo lsmod
  Module                  Size  Used by
  (...)
  psmouse                97578  0 
  serio_raw              13230  0 
  snd                    61351  4 snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer
  soundcore              12600  1 snd
  nfsd                  255559  2 
  (...)

 Les commandes ``modprobe`` et ``modinfo`` permettent respectivement d'installer/désinstaller des modules et d'obtenir de l'information sur un module. 
 Par exemple, la sortie suivante est un extrait du résultat de ``sudo modinfo psmouse``.
 
 .. code-block:: console
 
  $ sudo modinfo psmouse
  filename:       /lib/modules/3.13.0-32-generic/kernel/drivers/input/mouse/psmouse.ko
  license:        GPL
  description:    PS/2 mouse driver
  author:         Vojtech Pavlik <vojtech@suse.cz>
  (...)
  depends:        
  (...)

Structure en micro-noyau (L4)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les structures monolithiques, en couche, ou utilisant des modules que nous avons présenté précédemment ont toutes un défaut en commun : la quantité de code exécutée en mode protégé au sein du noyau est très importante.
Ceci pose un problème de fiabilité : une fonctionnalité incorrectement mise en œuvre dans le noyau (par exemple, qui accède à des adresses mémoires incohérentes en déréférencant un pointeur mal initialisé, ou qui utilisent une instruction de contrôle du matériel mal formée) peuvent affecter l'ensemble du noyau et donc l'ensemble du système.
Cela peut résulter en un crash complet de la machine voire, ce qui est encore moins souhaitable, en des corruptions des données ou en des fautes exploitables par des logiciels malicieux pour effectuer des opérations non autorisées (comme, par exemple, casser la propriété d'isolation).

Le concept de micro-noyau est une réponse à ce problème.
Il consiste à réduire la taille du code du noyau (et donc les fonctionnalités supportées) au strict nécessaire, et à mettre en œuvre le reste des fonctionnalités sous forme de programmes fonctionnant en espace utilisateur.

Les fonctionnalités fondamentales mises en œuvre dans le micro-noyau sont généralement une gestion basique de la mémoire, la gestion des processus légers (ou *threads*, que nous verrons en détail dans la prochaine partie du cours), et la communication entre processus. 
Les autres fonctionnalités, y compris les drivers de périphériques, fonctionnent sous forme de processus en mode utilisateur.
Ces processus jouent un rôle similaire aux modules décrits précédemment.
Toutefois, puisqu'ils ne sont plus dans l'espace mémoire du noyau, ils ne peuvent plus appeler les fonctionnalités des autres services directement, en utilisant des appels de fonctions standard.
Ils doivent à la place utiliser des communications inter-processus, en appelant pour cela un appel système spécifique.
Le micro-noyau se charge alors d'acheminer entre les deux processus les messages, sans que ceux-ci n'aient de visibilité mémoire commune, ce qui conserve la propriété d'isolation.

Les micro-noyaux ont un avantage majeur : le code fonctionnant en mode protégé est réduit au minimum et on peut alors se concentrer sur sa qualité.
Les contributions logicielles externes, comme les drivers de périphériques, peuvent contenir des erreurs ou essayer d'utiliser des instructions interdites.
Cela ne mettra toutefois pas en cause l'intégrité du système : comme pour un processus utilisateur qui effectuerait une opération interdite, le processus contenant le driver fautif sera simplement terminé (et éventuellement relancé) mais le reste du système ne sera pas affecté.
Le même raisonnement s'applique pour les fonctionnalités complexes, comme les systèmes de fichiers, donc la mise en œuvre peut atteindre plusieurs dizaines voire centaines de milliers de lignes de code C.
On comprend l'importance qu'a cette isolation lorsque l'on considère, comme le montre l'étude de Chou *et al.* en 2001 [Chou2001]_ ou celle de Palix *et al.* en 2011 [Palix2011]_ que les branches `drivers` et `fs` du noyau Linux contiennent souvent jusqu'à 7 fois plus d'erreurs par millier de lignes de code que les autres branches.

La principale raison pour laquelle le concept de micro-noyau n'est pas aussi répandu est que sa mise en œuvre efficace est particulièrement délicate.
En particulier, le mécanisme de passage de message *via* le noyau, qui remplace l'appel direct de fonctions entre modules, est plus coûteux que ce dernier.
À la place de placer des arguments sur la pile et de rediriger le compteur de programme vers une autre adresse du noyau, comme c'est le cas dans un noyau monolithique, avec un micro-noyau il est nécessaire de redonner le contrôle au système d'exploitation, qui doit copier le message à transmettre de l'espace mémoire d'un processus à un autre, et mettre en place plusieurs changements de contexte.
Cette opération, répétée de très nombreuses fois, peut gréver la performance si elle n'est pas parfaitement optimisée.
On peut illustrer ce phénomène avec le système d'exploitation historique Windows NT, introduit dans les années 1990.
Ce système d'exploitation était le premier système Windows qui ne dépendait pas du tout de MS-DOS.
Dans ses premières versions, les concepteurs de Microsoft avaient décidé d'adopter une approche micro-noyau mais ont progressivement décidé de ramener des fonctionnalités externalisées dans ce dernier, constatant la perte importante de performance.
Lorsque Windows NT a finalement évolué vers le système Windows XP, ce dernier était devenu *de facto* un système à noyau monolithique.
Ce n'est que quelques années plus tard, avec les premières versions de Mac OS X, et surtout avec l'amélioration des procédures d'échange de message, qu'une approche micro-noyau a pu être déployée avec succès dans un produit commercial.

De nos jours, on retrouve des systèmes d'exploitation à micro-noyaux dans les systèmes embarqués critiques avec les systèmes L4 et QNX par exemple.
Mac OS ainsi qu'iOS d'Apple sont des systèmes hybrides, combinant des fonctionnalités typiques d'un micro-noyau mais incluant des fonctionnalités qui pourraient en principe être externalisées en espace utilisateur, et ceci principalement pour des raisons de performance.

.. note:: Micro-noyau et logiciel formellement certifié

 Un système d'exploitation est un élément critique en ce qui concerne la sécurité et la sûreté de fonctionnement d'un système informatique.
 Si l'on peut parfois accepter qu'un ordinateur personnel "plante" lors de l'essai d'une version non stabilisée d'un système d'exploitation, il n'en est pas de même pour un système critique utilisé dans le domaine spatial ou pour le transport de passagers.
 De la même façon, un système d'exploitation peut être utilisé dans un domaine ou la protection des données est primordiale, comme par exemple sur un serveur qui hébergerait des données médicales.
 Il ne serait pas acceptable qu'un logiciel exécuté sur la même machine puisse accéder à ces données en forçant l'accès à l'espace mémoire d'un autre processus.
 
 Un système comme Linux contient pourtant des millions de lignes de code (à titre d'exemple, le dépôt `git` de Linux contient plus de 28 millions de lignes, principalement de C, comprenant toutefois très majoritairement des drivers de périphériques).
 Bien que des milliers de développeurs très talentueux travaillent constamment à découvrir des erreurs dans ce code, il est très difficile de garantir qu'un logiciel de cette taille en est complètement exempt.
 Certaines études [Chou2001]_ [Palix2011]_ montrent ainsi que certains bugs ne sont corrigés que plusieurs années après leur première identification !
 
 L'utilisation d'un micro-noyau peut réduire drastiquement la quantité de lignes de code à analyser et à débogguer, mais cela n'est pas toujours suffisant.
 Récemment, des concepteurs de systèmes d'exploitation spécialisés pour les applications critiques ont entrepris de certifier de façon *formelle* la qualité de leurs systèmes.
 Ce processus nécessite de spécifier les fonctionnalités du système d'exploitation, comme par exemple la totale isolation entre les espaces mémoires accessibles au différents processus, à l'aide d'un formalisme mathématique.
 Des logiciels spécialisés permettent ensuite de valider une mise en œuvre (en C) du système d'exploitation par rapport à cette spécification formelle de haut niveau.
 Cette opération est très complexe et coûteuse en ressources de calcul.
 Elle ne peut donc s'appliquer qu'à un logiciel de taille raisonnable, comme un micro-noyau.
 Le projet le plus avancé dans ce domaine est sans doute le système d'exploitation `seL4 <https://sel4.systems>`_ développé principalement par l'université de Sidney en Australie.
 Si seL4 ne comporte qu'une dizaine de milliers de lignes de C et moins d'un millier de lignes d'assembleur, la preuve mathématique de sa correction représente des millions de ligne de clauses mathématiques et un travail d'une ampleur considérable.
 Il faudra sans doute quelques années avant que les mêmes pratiques se généralisent aux systèmes d'exploitation grand public.

Démarrage du système d'exploitation
-----------------------------------

Nous terminons cette présentation de la structure des systèmes d'exploitation par une description du processus permettant le démarrage d'un système.
Lors de ce démarrage, plusieurs étapes sont nécessaires pour permettre de donner la main au :term:`noyau` du système d'exploitation.

Lors du démarrage de la machine, la mémoire principale se trouve dans un état indéterminé.
Un programme de démarrage (*bootstrap* en anglais) doit être exécuté pour charger le :term:`noyau` depuis le disque et démarrer celui-ci.
Ce programme de démarrage est généralement stocké dans une mémoire non volatile (souvent dénotée ROM, pour *Read-Only Memory*).
Cette mémoire ROM utilise une technologie différente de la mémoire principale, et son contenu n'est pas perdu lors de la mise hors tension de la machine.
En pratique, le type de mémoire utilisé n'est pas seulement en lecture seul (Read-Only) mais supporte des mises à jour occasionnelles nécessitant un programme spécial (on parle alors d'un *firmware*, et d'une mise à jour de *firmware*)

Le processeur reçoit lors du démarrage (ou du redémarrage) de la machine une interruption dite de remise à zéro.
Il charge alors son compteur de programme à la première adresse de la mémoire ROM.
Cette adresse contient la première instruction du programme de démarrage.
Ce dernier va en général effectuer tout d'abord un certain nombre de vérifications de la machine (comme par exemple l'absence d'erreur au niveau de la mémoire principale), initialiser les registres matériels, les bus de communication, et les gestionnaires de périphériques.

Ensuite, ce programme va devoir récupérer sur le disque le code du noyau à proprement parler, pour le copier en mémoire principale et enfin brancher vers sa première instruction.
Sur la plupart des systèmes, cette étape se déroule en deux temps : le programme de démarrage est seulement capable de lire le tout premier bloc d'un support de stockage (en général un disque dur ou SSD) dans lequel un programme de chargement plus complet est stocké.
C'est ce dernier qui va charger le code du noyau depuis son emplacement effectif sur le disque (le noyau n'est pas stocké dans le premier bloc, mais dans le système de fichier; sous Linux ce fichier est généralement stocké dans le répertoire ``/boot``, par exemple ``/boot/vmlinuz-3.13.0-32-generic``).
Sous Linux, le gestionnaire de démarrage GRUB joue ce rôle.
Il permet par ailleurs de gérer le démarrage de plusieurs systèmes (comme Solaris, Windows, etc.) ou bien de permettre le démarrage de différents noyaux pour un même système, ce qui est parfois utile pour les développeurs.
On notera que lors de l'exécution de GRUB, avant l'exécution du noyau Linux lui-même, les modules de Linux permettant d'utiliser le système de fichier ne sont pas chargés.
GRUB inclue donc ses propres modules pour pouvoir utiliser les systèmes de fichiers les plus courants et y localiser le fichier contenant le code du noyau.

.. Machines virtuelles et conteneurs
.. =================================
..
.. - Machines virtuelles
.. - Conteneurs
.. - Mentionner plus de matière en LINGI2145
