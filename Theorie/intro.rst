.. -*- coding: utf-8 -*-
.. Copyright |copy| 2012, 2023 by `Olivier Bonaventure <http://perso.uclouvain.be/olivier.bonaventure>`_, Etienne Rivière, Christoph Paasch et Grégory Detal
.. Ce fichier est distribué sous une licence `creative commons <http://creativecommons.org/licenses/by-sa/3.0/>`_

.. _introduction:
   
Introduction
============

.. spelling::

   Von Neumann
   binary
   digit
   word
   virtualisation

Les systèmes informatiques sont partout dans notre quotidien : de notre téléphone portable à notre montre connectée, de notre ordinateur de bureau aux très nombreux *serveurs* supportant les services internet que nous utilisons quotidiennement. De nombreux objets du quotidien sont eux-aussi des systèmes informatiques : on assiste ainsi à une explosion du nombre d'objets connectés (par exemple, des ampoules programmables ou des hauts-parleurs interactifs) et nombreux sont les objets qui intègrent désormais un ordinateur, comme les voitures ou les appareils électroménagers.

Malgré la diversité de leurs usages, tous ces appareils ont en commun des principes fondamentaux de fonctionnement et d'organisation. Un système informatique intègre toujours au moins un :term:`processeur` (:term:`CPU` en anglais), une mémoire, et un ou des dispositifs d'entrée/sortie lui permettant d'interagir avec son environnement.

Le :term:`CPU` est un circuit électronique réalisant très rapidement des opérations simples :

 - lire de l'information en mémoire;
 - effectuer des calculs élémentaires sur cette information;
 - écrire de l'information (le résultat) en mémoire.

Les opérations effectuées par le :term:`processeur` sont mises en œuvre directement de manière électronique. On parle d'*instructions*. Le jeu d'instruction mis en œuvre par un :term:`processeur` est fixe et dépend de son modèle. Par exemple, les ordinateurs Apple jusqu'en 2020 et l'ensemble des PCs récents utilisent des processeurs de marque Intel ou AMD permettant d'exécuter le jeu d'instruction ``x86_64``. Les ordinateurs Apple les plus récents utilisent un CPU mettant en œuvre le jeu d'instruction ``ARM A64``, le même que celui supporté par le processeur du nano-ordinateur RaspberryPI et de nombreux systèmes embarqués.

La très grande majorité des processeurs adoptent les principes de l'architecture dite de Von Neumann du nom du pionnier de l'informatique, `Jon von Neumann <https://fr.wikipedia.org/wiki/John_von_Neumann>`_. Suivant cette architecture, la mémoire principale est utilisée pour stocker aussi bien les informations traitées et produites par le programme à exécuter, que les instructions composant ce programme.

Représentation de l'information
-------------------------------

Un processeur manipule l'information sous forme binaire. L'élément de base pour stocker et représenter de l'information dans un système informatique est donc le :term:`bit`. Un bit (`binary digit` en anglais) peut prendre deux valeurs qui par convention sont représentées par :

 - ``1``
 - ``0``

Physiquement, un bit est représenté sous la forme d'un signal électrique ou optique lorsqu'il est transmis et d'une charge électrique ou sous forme physique (par exemple, magnétique) lorsqu'il est stocké. Nous n'aborderons pas ces détails technologiques dans le cadre de ce cours. Ils font l'objet de nombreux cours d'électronique.

Le bit est l'unité de base de stockage et de transfert de l'information. En général, les systèmes informatiques ne traitent pas des bits individuellement, mais par blocs. On appelle un :term:`nibble` un bloc de 4 bits consécutifs et un  :term:`octet` (ou :term:`byte` en anglais) un bloc de 8 bits consécutifs. On parle de mots (`word` en anglais) pour des groupes comprenant généralement 32 bits et de longs mots pour des groupes de 64 bits.

Suivant l'architecture de Von Neumann, les données tout comme les instructions à exécuter par le processeur sont stockées sous forme binaire dans la mémoire. Le processeur va donc lire la prochaine instruction à exécuter sous forme d'un groupe de bits, la déchiffrer, et appliquer l'effet prévu pour l'instruction correspondante, avant de recommencer. L'identité de l'instruction à exécuter est déterminée en décodant les premiers bits de l'instruction; le reste contient ses arguments ou *opérandes*. Par exemple, une instruction de lecture en mémoire peut spécifier (1) où la lecture doit se faire et (2) où stocker la valeur lue.

Un jeu d'instruction peut contenir des centaines d'instructions différentes. Certaines instructions ont pour objectif de déterminer la prochaine instruction à lire depuis la mémoire, décoder et exécuter. Ces instructions de *contrôle de flux* permettent de mettre en œuvre les structures de contrôle : conditionnelles (*if*) et boucles (*while*, etc.). La majorité des autres instructions effectuent des calculs, permettent de lire ou d'écrire des donnés depuis et vers la mémoire. Quelques instructions sont, comme nous le verrons, réservées au pilotage du comportement du processeur.

Interaction avec le monde extérieur
-----------------------------------

Le processeur et la mémoire ne sont pas les deux seuls composants d'un système informatique. Celui-ci doit également pouvoir interagir avec le monde extérieur, ne fut-ce que pour pouvoir charger le programme à exécuter et les données à analyser. Cette interaction se réalise grâce à un grand nombre de dispositifs d'entrées/sorties et de stockage. Parmi ceux-ci, on peut citer :

 - le clavier qui permet à l'utilisateur d'entrer des caractères;
 - l'écran qui permet à l'utilisateur de visualiser le fonctionnement des programmes et les résultats qu'ils produisent;
 - l'imprimante qui permet à l'ordinateur d'écrire sur papier les résultats de l'exécution de programmes;
 - le disque-dur ou SSD, les clés USB, les CDs et DVDs qui permettent de stocker les données sous la forme de fichiers et de répertoires;
 - la souris ou la tablette graphique qui permettent à l'utilisateur de fournir à l'ordinateur des indications de positionnement;
 - le scanner qui permet à l'ordinateur de transformer un document en une image numérique;
 - le haut-parleur avec lequel l'ordinateur peut diffuser différentes sortes de son;
 - le microphone et la caméra qui permettent à l'ordinateur de capturer des informations sonores et visuelles pour les stocker ou les traiter.

Les dispositifs d'entrée/sortie et de stockage sont gérés par des *contrôleurs de périphériques* spécifiques. Par exemple, un contrôleur de périphérique pour le clavier peut être un micro-contrôleur qui interagit avec le dispositif matériel et détecte la frappe de touches. Ce contrôleur de périphérique dispose d'une mémoire propre, qui contient suite à cette détection l'identifiant de la touche qui vient d'être frappée.

Il est nécessaire, lorsque l'utilisateur fait une saisie au clavier, que le système puisse récupérer l'information de la mémoire du contrôleur afin de la traiter. Les entrées/sorties se déroulent de manière concurrente (c'est à dire : *en même temps*) que l'exécution par le processeur des instructions du programme principal. Il est donc nécessaire de signaler au processeur qu'un évènement externe est survenu. Ceci est possible grâce au mécanisme d':term:`interruption`.

Une :term:`interruption` est un signal extérieur au processeur qui force celui-ci à arrêter l'exécution du programme en cours, et à passer le contrôle du processeur à une routine de traitement qui va pouvoir prendre en compte la raison de cette interruption. Cette routine va donc tout d'abord déterminer la cause de l'interruption, soit en interrogeant un à un les contrôleurs de périphériques soit en utilisant un *vecteur d'interruptions* qui indique directement lequel des contrôleurs est à la source de l'interruption. Un code de traitement spécifique est ensuite appelé qui peut, dans notre exemple, récupérer l'information de la mémoire interne du contrôleur du clavier pour la placer en mémoire principale.

Outre les contrôleurs de périphériques externes comme le clavier, la souris ou une manette de jeu, il existe de nombreuses sources d':term:`interruption` possibles de dispositifs ou périphériques internes : une horloge générant une interruption de manière périodique (par exemple, toutes les 10 millisecondes), un dispositif de stockage annonçant la complétion d'une opération d'écriture ou de lecture, ou encore un périphérique réseau annonçant la réception de données sur son interface.

.. topic:: L'accès direct à la mémoire ou DMA
  
  Nous avons vu qu'une interruption peut permettre le transfert par le processeur d'une information (e.g., la touche pressée au clavier) entre la mémoire du contrôleur et la mémoire principale. Cette méthode est adéquate pour les périphériques comme le clavier ou un manette de jeu qui génèrent un nombre très limité d'information à traiter (et donc d'interruptions) chaque seconde. Elle n'est toutefois pas viable pour les périphériques générant ou recevant de grandes quantités de données.
  
  Si chaque réception d'une donnée (par exemple, un mot de 32 bits) génère une interruption, l'écriture de données sur un périphérique de stockage, ou la réception d'une informations sur le réseau, va simplement saturer le processeur d'interruptions et empêcher l'exécution du programme principal. Le système est alors inutilisable pour autre chose que le traitement des entrées/sorties.
  
  Les systèmes informatiques modernes supportent le principe de :term:`DMA` pour *Direct Memory Access* ou accès direct à la mémoire. Avec DMA, un contrôleur de périphérique est autorisé à accéder directement à la mémoire principale pour y lire et écrire des données. Il n'est alors plus nécessaire de générer une interruption pour chaque mot lu ou écrit, mais seulement lorsqu'une qu'un bloc (ensemble) de données est disponible ou a été consommé. Cela permet au processeur de continuer d'exécuter le programme principal en *parallèle* de l'opération d'entrée/sortie.

Rôle(s) du système d'exploitation
---------------------------------

L'utilisation *directe* d'un système informatique par un programme unique est en théorie possible : c'est d'ailleurs ainsi que les premiers ordinateurs des années 1950 étaient utilisés.
Le programme devait alors prévoir les instructions spécifiques pour utiliser les ressources de l'ordinateur cible, et prendre en compte l'ensemble de ses caractéristiques matérielles.
Il était d'ailleurs courant que chaque ordinateur ait des caractéristiques uniques, nécessitant donc de programmer spécifiquement pour chaque environnement.
Très rapidement (dès la fin des années 1950) la nécessité d'un logiciel intermédiaire simplifiant et systématisant l'utilisation du matériel, comme par exemple la gestion des interruptions et des entrées/sorties que nous venons de décrire, et permettant d'uniformiser l'utilisation des ordinateurs, s'est imposé.
Tout système informatique comprend ainsi depuis un *système d'exploitation*.

Un système d'exploitation remplit trois rôles principaux :

 - Le premier rôle du système d'exploitation est de rendre l'exécution et l'utilisation de programmes "utiles" pour l'utilisateur plus aisée et systématique, en simplifiant l'utilisation de ressources matérielles de nature pourtant hétérogènes.
 - Son deuxième rôle est de rentre l'utilisation de ces ressources plus efficace, en permettant par exemple le recouvrement entre les opérations d'entrée/sortie et l'exécution des programmes, ou l'utilisation du système par plusieurs programmes et/ou plusieurs utilisateurs *à la fois*. 
 - Son troisième rôle, enfin, est d'assurer la sécurité et l'intégrité du système informatique lui même et des données qui lui sont confiées. Par exemple, un programme qui rencontre une erreur (par exemple, qui essaie d'exécuter une instruction qui n'existe pas) ne doit pas remettre en cause ou stopper l'exécution des autres programmes, et les données d'un utilisateur doivent pouvoir être protégées de l'accès par d'autres utilisateurs du même système.

Le système d'exploitation remplit ces trois rôles grâce à la **virtualisation** des ressources matérielles. À partir de ressources matérielles de natures variées, le système d'exploitation construit des représentations virtuelles. Ces représentations sont plus faciles à utiliser pour les programmeurs d'applications, et disponibles au travers d'interfaces programmatiques (`Application Programming Interfaces` en anglais - :term:`API`). Par ailleurs, ces représentations sont généralement à visée universelle, c'est à dire qu'elles ne diffèrent pas (ou très peu) d'un système d'exploitation à l'autre, même lorsque les systèmes informatiques et le matériel les composant diffèrent fortement.

Exemples de virtualisation 
^^^^^^^^^^^^^^^^^^^^^^^^^^

Nous illustrons ci-dessous le principe de virtualisation en utilisant trois exemples. Bien entendu, l'objectif dans cette introduction n'est pas de comprendre *en détail* les mécanismes et algorithmes permettant leur mise en œuvre, que nous couvrirons dans les chapitres dédiés de ce cours, mais d'illustrer le principe général.

On peut tout d'abord illustrer le principe de virtualisation avec l'utilisation des dispositifs de stockage. Il existe de nombreux dispositifs de stockage différents (disque dur, clé USB, CD, DVD, mémoire flash, ...). Chacun de ces dispositifs a des caractéristiques électriques et mécaniques propres. Ils permettent en général la lecture et/ou l'écriture de blocs de données de quelques centaines ou milliers d'octets à la fois. Nous reviendrons sur leur fonctionnement ultérieurement. Peu d'applications sont capables de piloter de tels dispositifs pour y lire ou y écrire des blocs de données directement, et même si c'était le cas la prise en compte de tous les types de dispositifs disponibles sur le marché serait impossible. Par contre, toutes des applications sont capables d'utiliser ces systèmes de stockage par l'intermédiaire du *système de fichiers*, un des composants d'un système d'exploitation. La représentation virtualisée qu'est le système de fichiers (arborescence des fichiers, de répertoires, etc.) et l'API associée (`open(2)`_, `close(2)`_, `read(2)`_, `write(2)`_) sont un exemple des services fournis par le système d'exploitation aux applications.

Un deuxième exemple de virtualisation est la notion de :term:`processus`. Celle-ci est une représentation virtuelle de la notion de programme principal s'exécutant sur le processeur. Elle permet le partage d'un processeur unique (ou d'un ensemble de processeurs) entre plusieurs programmes appartenant à un ou plusieurs utilisateurs. Un processus est l'exécution d'une suite d'instructions contenue dans un fichier programme. Le système d'exploitation donne l'illusion à chaque processus qu'il s'exécute de façon totalement isolée sur un processeur qui lui est dédiée, mais en réalité plusieurs processus alternent leur exécution sur un (ou quelques) processeur(s) partagé(s). Le système d'exploitation met en œuvre la notion de processus en alternant rapidement l'exécution de ces processus sur le ou les processeur(s). Ce principe permet de répondre au deuxième rôle du système d'exploitation, celui de l'efficacité. Lorsqu'un processus doit, par exemple, attendre la complétion d'une entrée/sortie (par exemple, si celui-ci attend qu'une touche du clavier soit pressée, que l'interruption correspondante arrive et qu'elle soit traitée, avant de pouvoir reprendre son exécution), le processeur peut être utilisé par un autre processus.

Un troisième et dernier exemple est la notion de *mémoire virtuelle*. Elle répond à deux problématiques :

 - La mémoire physique est une ressource limitée, dont le volume varie selon les systèmes. Un partage *explicite* de la mémoire physique entre processus est complexe à mettre en œuvre : dans les systèmes d'exploitation plus anciens ayant fait ce choix, chaque processus devait prendre en compte, pour accéder à ses instructions et à ses données, les limites de l'espace en mémoire physique qui lui était alloué dynamiquement lors de son initialisation. L'espace mémoire disponible pour chaque processus était fixé une fois pour toute lors de cette initialisation, même si seulement une partie était utilisée en réalité.
 - Un deuxième problème est celui de l'isolation entre processus. Idéalement, les données utilisées par un processus ne doivent pas être accessibles par les autres processus s'exécutant sur le système.

La mémoire virtuelle répond élégamment à ces deux problématiques en offrant à chaque processus une vision *virtuelle* d'un espace mémoire de taille fixe (très grande) et dédié, dans lesquelles les adresses déterminées lors de la compilation du programme sont directement valides sans transposition. Un programme est libre d'allouer et d'utiliser une quantité arbitraire de mémoire (dans les limites de quotas fixés par le système d'exploitation, mais pas nécessairement dans les limites de la mémoire physique disponible). Les données stockées en mémoire physique pour un processus :math:`P_A` ne sont pas accessibles *via* la mémoire virtuelle d'un processus :math:`P_B`, sauf si celui-ci l'a explicitement demandé. La mémoire virtuelle participe ainsi des trois rôles du système d'exploitation.

Nous verrons en détails dans ce cours comment tirer parti de ces abstractions. Nous allons maintenant aborder de façon introductive la question de leur mise en œuvre au sein d'un système d'exploitation moderne.

Mise en œuvre du système d'exploitation
---------------------------------------

La mise en œuvre d'un système d'exploitation est une tâche complexe, qui doit prendre en compte plusieurs facteurs possiblement contradictoires :

 1. la nécessité de fournir des abstractions et virtualisations des ressources les plus simples possibles à utiliser pour les programmeurs (et donc de plus haut niveau possible) ;
 2. l'universalité des fonctionnalités, permettant de supporter des applications et usages variés avec un même système d'exploitation ;
 3. la performance et le surcoût de ces couches d'abstraction et de virtualisation ;
 4. leur complexité de mise en œuvre, et ce faisant, la complexité de leur mise en œuvre *correcte* (sans bug).

La conception d'un système d'exploitation est donc souvent une affaire de compromis entre ces différents aspects. 
Les coûts de mise en œuvre d'une abstraction dépendent par ailleurs fortement des capacités du matériel utilisé.
Nous avons vu plus haut l'exemple de la DMA, permettant le transfert de données par blocs, directement entre un contrôleur de périphérique et la mémoire.
Sans le support matériel de la DMA, un système d'exploitation ne peut pas mettre en œuvre efficacement le recouvrement entre les phases d'entrée/sortie d'un processus et les phases de traitement d'un autre processus.
Les fonctionnalités des processeurs ont évolué, en réalité, conjointement à celle des systèmes d'exploitation, afin de permettre la mise en œuvre d'abstractions et de virtualisations plus poussées à un coût raisonnable.

Nous verrons plusieurs exemples de support matériel à la virtualisation des ressources et aux fonctions des systèmes d'exploitation dans ce cours. À titre d'illustration, nous allons utiliser le cas de la mémoire virtuelle dans cette introduction.

.. topic:: Le compromis entre abstraction et performance : exemple de la mémoire virtuelle

  Comme expliqué précédemment, la mémoire virtuelle a de grands avantages : elle offre à chaque processus l'illusion d'un espace mémoire de grande taille qui lui est dédié et dont la structure est connue à l'avance (par exemple, la première instruction à exécuter est toujours au même emplacement, la :term:`pile` commence toujours au même endroit, etc.).
  Le principe de mémoire virtuelle est connu depuis la fin des années 1950, et a été mis en œuvre dans des super-ordinateurs dès les années 1960.
  On peut donc s'interroger : pourquoi des systèmes d'exploitation pour PC jusqu'aux années 1990 (comme MS-DOS), et des systèmes d'exploitations actuels pour systèmes embarqués (comme `uCLinux <https://en.wikipedia.org/wiki/%CE%9CClinux>`_) ne supportent-ils pas le concept de mémoire virtuelle, et gèrent le partage de la mémoire physique de façon explicite, en indiquant aux processus la plage d'adresses *physiques* qu'ils sont en droit d'utiliser ?
  
  Pour comprendre cela, décrivons de façon simplifiée le fonctionnement de la mémoire virtuelle.
  Nous le reverrons en détail lors du cours dédié.
  Un processus :math:`P_A` est composé d'instructions utilisant des adresses en mémoire virtuelle. 
  Une adresse virtuelle correspond a une adresse en mémoire physique, mais cette correspondance est seulement déterminée lors de l'exécution du programme.
  Il est donc nécessaire de faire la traduction dynamique entre des adresses virtuelles et des adresses physiques, et ce pour chaque instruction accédant à la mémoire en lecture ou écriture.
  Par exemple, l'adresse virtuelle ``0x0000FF00`` pour le processus :math:`P_A` peut correspondre à l'adresse ``0x5FD6FF00`` en mémoire physique.
  Cette traduction est effectuée en consultant une structure de donnée stockée elle aussi en mémoire, appelée la :term:`table des pages`.
  Sans support matériel spécifique, il est nécessaire de transformer toute lecture ou écriture dans la mémoire en deux opérations :
  
   1. Lire la page des tables du processus en cours pour déterminer la correspondance entre adresse virtuelle et adresse physique ;
   2. Traduire l'adresse et effectuer l'opération de lecture ou écriture.
  
  L'opération (1) demande systématiquement (au moins) un accès mémoire supplémentaire pour lire la page des tables.
  Chaque accès mémoire dans le programme original est ainsi transformé en (au moins) *deux* accès mémoire.
  La mémoire étant typiquement un facteur limitant la performance d'exécution des processus, le temps d'exécution peut être simplement doublé ! 
  Dans ces conditions, le compromis entre utilité et coût n'est clairement pas favorable à la mise en œuvre de la mémoire virtuelle.
  
  Pour cette raison, quasiment tous les processeurs modernes intègrent un circuit dédié à la gestion de la virtualisation de la mémoire, appelé la :term:`MMU` (Memory Management Unit).
  La MMU conserve dans une mémoire très rapide des informations sur les associations entre adresses virtuelles et adresses physiques les plus récemment utilisées, et peut assurer la traduction *en ligne* des adresses. 
  Cela permet, dans la grande majorité des cas, que l'accès mémoire soit aussi rapide qu'un accès direct.
  Lorsque l'information n'est pas disponible, en revanche, le coût est important : le système d'exploitation doit reprendre la main pour fournir l'information nécessaire à la MMU, ce qui peut prendre un temps équivalent à des centaines voire des milliers d'opérations en mémoire.
  Comme ce cas de figure n'arrive pas souvent (nous verrons pourquoi), le support matériel qu'est la MMU permet de fournir l'abstraction de haut niveau qu'est la mémoire virtuelle à un coût qui est désormais considéré comme acceptable en regard de la plus-value qu'elle apporte.

Mécanisme vs. politique
^^^^^^^^^^^^^^^^^^^^^^^

Un autre aspect important de la mise en œuvre des systèmes d'exploitation, et dont nous discuterons régulièrement dans ce cours, est la séparation entre les mécanismes permettant d'abstraire une ressource matérielle, et les politiques arbitrant le partage de cette ressource (entre les différent programmes, les différents utilisateurs, etc.).

Illustrons ce principe avec l'abstraction de la ressource processeur *via* la notion de processus.
Comme nous l'avons expliqué précédemment, chaque processus a l'illusion de s'exécuter sur un processeur unique.
En réalité, le système d'exploitation partage le temps de chaque processeur entre l'ensemble des processus disponibles.
Un seul processus peut s'exécuter sur un processeur à un moment donné.
Régulièrement, le système d'exploitation va donc alterner le processus s'exécutant sur chaque processeur, afin que chaque processus ait régulièrement l'occasion d'exécuter des instructions.
L'abstraction processus nécessite donc :

 1. Un **mécanisme** permettant d'alterner un processus pour un autre sur un processeur. Ce mécanisme est appelé le :term:`changement de contexte`. Il consiste en deux phases : (1) la sauvegarde de l'état complet du processeur exécutant le premier processus (valeurs des registres, prochaine instruction à exécuter, etc.) dans la mémoire et (2) la restauration de l'état tel que sauvegardé en mémoire du second processus, afin de remettre le processeur dans l'état exact où celui-ci se trouvait lors de sa précédente interruption.
 2. Une **politique** qui décide lesquels des processus disponibles pour l'exécution doivent se voir allouer un processeur quand celui-ci devient disponible, ou même quand un processus en cours d'exécution doit être interrompu. On appelle cette politique une :term:`politique d'ordonnancement` (*scheduling* en anglais).

Le mécanisme de :term:`changement de contexte` doit avoir un coût le plus faible possible, car son utilisation est un pur surcoût pour le système.
La définition de la politique adéquate, en revanche, est plus subtile car elle dépend des objectifs du système informatique considéré.
Par exemple, on peut vouloir un partage équitable du temps processeur entre les différents utilisateurs, ou au contraire privilégier des tâches par rapport à d'autres.
Pour certaines tâches, comme des simulations de modèles mathématiques, on cherchera à maximiser le *débit applicatif*, c'est à dire le nombre d'instructions utiles effectuées par seconde : on préfèrera alors le moins de changements de contexte possible.
Pour d'autres processus dits *interactifs* on cherchera à minimiser le temps d'attente entre la disponibilité du processus pour être exécuté et la mise à disposition d'un processeur : ici, au contraire, on voudra alterner les processus rapidement pour minimiser le temps d'attente.
Ce dernier cas pourrait être par exemple celui d'une application de jeu vidéo de réflexes utilisant le clavier.
Sur la base de notre exemple de l'entrée/sortie clavier au début de cette introduction, on peut souhaiter minimiser le temps entre la réception de l'interruption depuis le contrôleur de périphérique clavier et le temps auquel le processus du jeu peut prendre en compte cette commande.

Interaction entre les applications et le système d'exploitation
---------------------------------------------------------------

Le système d'exploitation fournit des services aux applications permettant de simplifier et d'uniformiser l'utilisation des ressources du système informatique.
Certains de ces services sont accessibles sous la forme de programmes utilitaires permettant la gestion du système ou son utilisation (comme, par exemple, un gestionnaire de login, un serveur `ssh(1)`_, ou un interpréteur de commande).
D'autres sont accessibles sous la forme d'*appels système*; ceux-ci sont appelés directement par un programme ou, le plus souvent, utilisés par une librairie (comme la :term:`libc`) qui facilite leur utilisation.

La mise en œuvre des appels systèmes participe du troisième rôle d'un système d'exploitation, qui est celui de l'isolation des programmes (et des utilisateurs) entre eux.
Les processeurs modernes fournissent (au minimum) deux modes d'exécution :

 - Le *mode utilisateur* est celui utilisé par les processus courants des utilisateurs, ainsi que par les utilitaires fournis par le système d'exploitation. En mode utilisateur, les programmes utilisent les abstractions fournies par le système d'exploitation comme la mémoire virtuelle, les processus, ou le système de fichiers. Certaines opérations, et l'accès à certaines parties de la mémoire, ne sont pas autorisées en mode utilisateur. Elles seront refusées par le processeur. Par exemple, il n'est pas permis d'utiliser les instructions configurant le traitement des interruptions en mode utilisateur (c'est raisonnable : bloquer le traitement des interruptions permettrait de bloquer le système informatique complet sans possibilité de corriger le tir).
 - Le *mode protégé* est utilisé par le noyau du système d'exploitation. Le noyau est le composant de plus bas niveau, qui interagit directement avec le matériel. Les instructions qui ne sont pas autorisées en mode utilisateur, comme la configuration des interruptions, ou l'envoi d'instructions aux gestionnaires de périphériques, etc. sont autorisées en mode protégé.

L'utilisation de ces deux modes permet d'assurer l'isolation entre les processus s'exécutant en mode utilisateur, tout en permettant au noyau de gérer les ressources de manière globale.
L'ensemble des ressources du système informatique, et donc l'ensemble des données stockées par les processus utilisateurs en mémoire, sont accessibles au noyau : la sécurité de ce composant est donc critique !

Un appel système permet d'utiliser une fonctionnalité (par exemple, créer un nouveau processus) qui requiert une action du noyau.
Afin d'utiliser un appel système, un processus utilisateur va tout d'abord préparer les arguments de cet appel, comme on le ferait pour un appel de fonction classique.
Le passage en mode noyau afin de demander le service de cet appel ne revient pas, en revanche, à un appel de fonction classique (où l'on *branche* vers la première instruction de la fonction à exécuter).
À la place, le processus appelant doit générer une *interruption logicielle*, ou :term:`trap`.
Cette interruption fonctionne d'une manière similaire aux interruptions matérielles évoquées précédemment.
Le processeur va automatiquement passer en mode protégé et exécuter le code du point d'entrée du noyau.
Ce code va déterminer l'appel système à traiter puis enfin brancher vers la partie du code du noyau en charge de cette opération, qui va généralement commencer par vérifier que cet appel est autorisé pour le processus considéré.
À la fin du traitement de l'appel système, le contrôle revient au processus appelant en mode utilisateur.

On notera que les interruption logicielles sont aussi utiles pour permettre au système d'exploitation de traiter les erreurs d'un processus particulier sans que les autres processus ne soient affectés.
Par exemple, si un processus tente d'effectuer une opération interdite comme une division par zéro, ou bien tente d'accéder à une partie de la mémoire non autorisée (le fameux ``segmentation fault`` que vous avez peut-être déjà rencontré) alors le processeur génère une interruption logicielle, redonnant ainsi le contrôle au système d'exploitation et permettant de traiter le problème (par exemple, en affichant un message d'erreur, en terminant le processus et en libérant les ressources qu'il utilisait).

.. spelling::

   API
   l'API
   Bell
   Laboratories
   AT&T
   Berkeley
   Labs
   Amsterdam
   d'Amsterdam
   raspberry
   pi
   nano

Unix
----

Il existe de nombreux systèmes d'exploitation, visant des usages variés, des objets connectés (comme `RIOT <https://www.riot-os.org>`_) aux super-calculateurs, en passant par les ordinateurs personnels (comme Windows ou MacOS).
:term:`GNU/Linux` est aujourd'hui le système d'exploitation le plus répandu dans le monde.
En effet, des déclinaisons de systèmes utilisant :term:`Linux` équipent des systèmes informatiques de nature très variées, comme les smartphones (Android), l'immense majorité des serveurs et la totalité des plus grands `supercalculateurs <https://www.top500.org>`_.

:term:`GNU/Linux` est un représentant de la famille de systèmes d'exploitation Unix. Unix est aujourd'hui un nom générique [#funix]_. La première version de Unix a été développée pour faciliter le traitement de documents sur mini-ordinateur.

.. topic:: Quelques variantes de Unix

 De nombreuses variantes de Unix ont été produites durant les quarante dernières années. Il est impossible de les décrire toutes, mais en voici quelques unes.

   - :term:`Unix`. Initialement développé aux AT&T Bell Laboratories, Unix a été ensuite développé par d'autres entreprises. C'est aujourd'hui une marque déposée par ``The Open group``, voir http://www.unix.org/
   - :term:`BSD Unix`. Les premières versions de Unix étaient librement distribuées par Bell Labs. Avec le temps, des variantes d'Unix sont apparues. La variante développée par l'université de Berkeley en Californie a été historiquement importante car c'est dans cette variante que de nombreuses innovations ont été introduites dont notamment les piles de protocoles TCP/IP utilisées sur Internet. Aujourd'hui, :term:`FreeBSD` et :term:`OpenBSD` sont deux descendants de :term:`BSD Unix`. Ils sont utilisés dans de nombreux serveurs et systèmes embarqués. :term:`MacOS`, développé par Apple, s'appuie fortement sur un noyau et des utilitaires provenant de :term:`FreeBSD`.
   - :term:`Minix` est un système d'exploitation développé initialement par :term:`Andrew Tanenbaum` à l'université d'Amsterdam. :term:`Minix` est généralement utilisé pour l'apprentissage du fonctionnement des systèmes d'exploitation.
   - :term:`Linux` est un noyau de système d'exploitation largement inspiré de :term:`Unix` et de :term:`Minix`. Développé par :term:`Linus Torvalds` durant ses études d'informatique, il est devenu la variante de Unix la plus utilisée à travers le monde. Il est maintenant développé par des centaines de développeurs qui collaborent via Internet.
   - :term:`Solaris` est le nom commercial d'une variante Unix développée par Oracle.

 Dans le cadre de ce cours, nous nous focaliserons sur le système :term:`GNU/Linux`, c'est-à-dire un système qui intègre le noyau :term:`Linux` et les librairies et utilitaires développés par le projet :term:`GNU` de la :term:`FSF`.

Un système Unix est composé de trois grands types de logiciels :

 - Le noyau du système d'exploitation qui est chargé en mémoire au démarrage de la machine et qui prend en charge toutes les interactions entre les logiciels et le matériel.
 - De nombreuses librairies qui facilitent l'écriture et le développement d'applications.
 - De nombreux programmes utilitaires simples qui permettent de résoudre la plupart des problèmes courants. Certains de ces utilitaires sont chargés automatiquement lors du démarrage de la machine. Ils sont généralement exécutés uniquement à la demande des utilisateurs.

.. spelling::

   API
   programmatiques
   Application
   Programming
   Interface

Les systèmes de la famille Unix présentent généralement une arborescence de fichiers unique (contrairement, par exemple, à Windows qui utilise le principe de "volumes" séparés). La racine de cette arborescence est le répertoire ``/`` par convention. Ce répertoire contient généralement une dizaine de sous répertoires dont les noms varient d'une variante de Unix à l'autre. Généralement, on retrouve dans la racine les sous-répertoires suivants :

 - ``/usr`` : sous-répertoire contenant la plupart des utilitaires et librairies installées sur le système;
 - ``/bin`` et ``/sbin`` : sous-répertoires contenant quelques utilitaires de base nécessaires à l'administrateur du système;
 - ``/tmp`` : sous-répertoire contenant des fichiers temporaires. Son contenu est généralement effacé au redémarrage du système;
 - ``/etc`` : sous-répertoire contenant les fichiers de configuration du système;
 - ``/home`` : sous-répertoire contenant les répertoires personnels des utilisateurs du système;
 - ``/dev`` : sous-répertoire contenant des fichiers spéciaux;
 - ``/root``: sous-répertoire contenant des fichiers propres à l'administrateur système. Dans certains variantes de Unix, ces fichiers sont stockés dans le répertoire racine.

Les systèmes Unix ont introduit une bonne partie des concepts et abstractions modernes fournies par les systèmes d'exploitation, comme le partage et l'isolation de la mémoire ou la notion de processus.
L'exécution d'un processus est initiée par le système d'exploitation (généralement suite à une requête faite par un autre processus). Ce processus peut s'exécuter pendant une fraction de secondes, quelques secondes ou des journées entières. Pendant son exécution, le processus peut potentiellement accéder aux différentes ressources (processeurs, mémoire, dispositifs d'entrées/sorties et de stockage) du système en utilisant des appels systèmes (ou en appelant des fonctions de la librairie standard utilisant ces appels système).
À la fin de son exécution, le processus se termine [#ftermine]_ ce qui permet au système d'exploitation de libérer les ressources qui lui avaient été allouées. Sous un système d'exploitation Unix, tout processus qui se termine retourne au processus qui l'avait créé le résultat de son exécution qui est résumée par un nombre entier. Cette valeur de retour est utilisée en général pour déterminer si l'exécution d'un processus s'est déroulée correctement (zéro comme valeur de retour) ou non (valeur de retour différente de zéro).

Dans le cadre de ce cours, nous aurons l'occasion de voir en détails de nombreuses librairies d'un système Unix et verrons le fonctionnement d'appels systèmes qui permettent aux logiciels d'interagir directement avec le noyau. Le système Unix étant majoritairement écrit en langage C, ce langage est le langage de choix pour de nombreuses applications. Nous le verrons donc en détails.

.. rubric:: Footnotes

.. [#funix] Formellement, Unix est une marque déposée par l'`Open Group <http://www.opengroup.org>`_, un ensemble d'entreprises qui développent des standards dans le monde de l'informatique. La première version de Unix écrite en C date de 1973, http://www.unix.org/what_is_unix/history_timeline.html

.. [#ftermine] Certains processus sont lancés automatiquement au démarrage du système et ne se terminent qu'à son arrêt. Ces processus sont souvent appelés des `daemons`. Il peut s'agir de services qui fonctionnent en permanence sur la machine, comme par exemple un serveur web ou un `daemon` d'authentification.

