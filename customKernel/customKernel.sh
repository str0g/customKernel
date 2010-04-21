#! /bin/bash

#########################################
#Author Łukasz Buśko			#
#Contact buskol.waw.pl@gmail.com	#
#Licens GPL				#
#########################################

#parametry
Czas=$(date +%s);
sciezka=$(grep sciezka= config.conf)
sciezka=${sciezka#sciezka=}
nazwa_kernela=$(grep nazwa_kernela= config.conf)
nazwa_kernela=${nazwa_kernela#nazwa_kernela=}
sciezka_do_kernela=$(grep sciezka_do_kernela config.conf);
sciezka_do_kernela=${sciezka_do_kernela#sciezka_do_kernela=}
nr_kernela=$(grep nr_kernela= config.conf);
nr_kernela=${nr_kernela#nr_kernela=}
nr_kernela2=$(grep nr_kernela2= config.conf);
nr_kernela2=${nr_kernela2#nr_kernela2=}
log=''$(grep log= config.conf)''$nr_kernela'_'$nazwa_kernela'.txt';
log=${log#log=}
specjalnaNazwaKernela=$(grep specjalnaNazwaKernela= config.conf);
specjalnaNazwaKernela=${specjalnaNazwaKernela#specjalnaNazwaKernela=}
kartaNV=$(grep kartaNV= config.conf);
kartaNV=${kartaNV#kartaNV=}
Language=$(grep Language= config.conf);
Language=${Language#Language=}

FLAGA_instalacji=1;
FLAGA_compilacji=1;
VersjaScryptu="0.7b";

function PROMPT_INPUT
{
params=$#
param=1
while [ "$param" -le "$params" ]
do
case $(eval echo \$$param) in
  --help | -h | -V )
	if [ $Language == 'Polski' ]; then
		echo $'Dostepne opcje:\n --help, --h\n --version, --v\n --install-only, --o-i\n --compile-only, --c-o\n--install-packets, --i-p\n'
	elif [ $Language == 'English' ]; then
		echo $'Available options:\n --help, --h\n --version, --v\n --install-only, --o-i\n --compile-only, --c-o\n--install-packets, --i-p\n'
	else
		echo $'Available options:\n --help, --h\n --version, --v\n --install-only, --o-i\n --compile-only, --c-o\n--install-packets, --i-p\n'
	fi
	exit 0
	;;
  --version | -v | -V )
	if [ $Language == 'Polski' ]; then
		echo $'Wersja: '$VersjaScryptu''
		echo $'Autor Lukasz Busko\nKontact buskol.waw.pl@gmail.com\nLicencja: General Public License'
	elif [ $Language == 'English' ]; then
		echo $'Version: '$VersjaScryptu''
		echo $'Author Lukasz Busko\nKontact buskol.waw.pl@gmail.com\nLicense: General Public License'
	else
		echo $'Version: '$VersjaScryptu''
		echo $'Author Lukasz Busko\nKontact buskol.waw.pl@gmail.com\nLicense: General Public License'
	fi
	exit 0
	;;
  --install-only | --i-o | -V ) 
	FLAGA_compilacji=0;
	;;
  --compile-only | --c-o |-V )
	FLAGA_instalacji=0;
	;;
  --install-packets | --i-p |-V )
	if [ $Language == 'Polski' ]; then
		echo $'Zachwile zostana zainstalowane pakiety, aby przerwac operacje nacisnij CTRL+C'
	elif [ $Language == 'English' ]; then
		echo $'Packets will be installed in a moment, to cancel press CTRL+C'
	else
		echo $'Packets will be installed in a moment, to cancel press CTRL+C'
	fi
	sleep 3
	sudo apt-get -y install "make" kernel-package libncurses5-dev fakeroot "wget" "bzip2" build-essential 
	;;
  *)
	if [ $Language == 'Polski' ]; then
		echo $'Dostepne opcje:\n --help\n --version\n --install-only, --o-i\n --compile-only --c-o\n, --install-packets, --i-p\n'
	elif [ $Language == 'English' ]; then
		echo $'Available options:\n --help, --h\n --version, --v\n --install-only, --o-i\n --compile-only, --c-o\n--install-packets, --i-p\n'
	else
		echo $'Available options:\n --help, --h\n --version, --v\n --install-only, --o-i\n --compile-only, --c-o\n--install-packets, --i-p\n'
	fi
	exit 0
	;;
esac
(( param ++ ))
done
}

function SPR_FLAGI
{

if [ $FLAGA_compilacji -eq 0 ] && [ $FLAGA_instalacji -eq 0 ]; then
	if [ $Language == 'Polski' ]; then
		echo $'Nie ma nic do zrobienia!'
	elif [ $Language == 'English' ]; then
		echo $'Nothing to be done!'
	else
		echo $'Nothing to be done!'
	fi
	sleep 5
	exit 1
fi
}

function CZYSZCZENIE
{
	cd $sciezka_do_kernela$sciezka
	if [ $Language == 'Polski' ]; then
		echo $'Czyszczenie'
	elif [ $Language == 'English' ]; then
		echo $'Cleaning'
	else
		echo $'Cleaning'
	fi
#	rm -r usr
#	rm linux-source-$nr_kernela2.tar.bz2
	if [ $Language == 'Polski' ]; then
		echo $'\n'$(date)'\t\t==>Czyszczenie po instalacyjne<==' >> $log
	elif [ $Language == 'English' ]; then
		echo $'\n'$(date)'\t\t==>Cleaning after installation<==' >> $log
	else
		echo $'\n'$(date)'\t\t==>Cleaning after installation<==' >> $log
	fi
	cp linux/.config config_backup >> $log 2>&1
	rm -r 'linux-source-'$nr_kernela2'' linux >> $log 2>&1
}

function CZYROOT
{
if [ $(id -u) != 0 ]; then
	if [ $Language == 'Polski' ]; then
	 echo $'Skrypt samoczynnie wlaczy sie jeszcze raz poniewaz nie masz wystarczajacych uprawnien!\n Jezeli nie masz uprawnien Roota lub nie chcesz kontynuowac przerwij jego dzialanie CTRL+C'
	elif [ $Language == 'English' ]; then
	  echo $'Script will restart it self if you havent enough privilege!\n If you havent Root privilege or you dont want to continue press CTRL+C'
	else
	  echo $'Script will restart it self if you havent enough privilege!\n If you havent Root privilege or you dont want to continue press CTRL+C'
	fi
  sudo ././customKernel.sh $*
  exit 1
fi
}

bashtrap() #Przerywanie
{
#	CZYSZCZENIE

	if [ $Language == 'Polski' ]; then
		#echo "Przerwano przez uzytkownika!" #Nie potrzebny komunikat?
		echo $''$(date)'\t\t==>Przerwano przez uzytkownika!<==' >> $log   
	elif [ $Language == 'English' ]; then
		#echo "Aborted by user!"
		echo $''$(date)'\t\t==>Aborted by user!<==' >> $log  
	else
		#echo "Aborted by user!"
		echo $''$(date)'\t\t==>Aborted by user!<==' >> $log 
	fi
}

function blad_przerwanie #Informacje o bledzie
{
	if [ $Language == 'Polski' ]; then
		echo $'\nNie udane utworzenie kernela '$(date)'\n' >> $log 
	elif [ $Language == 'English' ]; then
		echo $'\nFaild to create Kernel '$(date)'\n' >> $log 
	else
		echo $'\nFaild to create Kernel '$(date)'\n' >> $log 
	fi
}

function tworzenie_logow #SPRAWDZANIE ISTNIENIA LOGOW
{
	if [ -e $log ]; then
		if [ $Language == 'Polski' ]; then
			echo "Plik $log istnieje logi zostana dopisane"
		elif [ $Language == 'English' ]; then
			echo "File $log exists logs will be append"
		else
			echo "File $log exists logs will be append"
		fi
	else 
		if [ $Language == 'Polski' ]; then
			echo "Plik $log nie istnieje tworze"
		elif [ $Language == 'English' ]; then
			echo "File $log does not exist, creating..."
		else
			echo "File $log does not exist, creating..."
		fi
		touch $log
		if [ ! -e $log ]; then
			if [ $Language == 'Polski' ]; then
				echo "Nie udalo sie utworzyc $log"
			elif [ $Language == 'English' ]; then
				echo "Couldnt't create $log"
			else
				echo "Couldnt't create $log"
			fi
			sleep 3
			exit 1	
		fi
	fi 
}

function rozpakowywanie_zrodel #ROZPAKOWYWANIE ZRODEL
{
echo $'\nRozpakowywuje archiwom ze zrodlem kernela\n'

	#if [ ! -e linux-source-$nr_kernela2.tar.bz2 ]; then
	#	echo $'\nlinux-source-'$nr_kernela2'.tar.bz2 nie istnieje'
	#	blad_przerwanie
	#	sleep 3		
	#	exit 1	
	#fi

if [ -e 'linux-source-'$nr_kernela2'_'$nr_kernela'_all.deb' ]; then
	ar p 'linux-source-'$nr_kernela2'_'$nr_kernela'_all.deb' data.tar.gz | tar zx
#TUTAJ JEST BLAD, brak wykrycia poprawnego rozpakowania.	
	if [ $? -eq 1 ]; then
		echo $'Rozpakowanie paczki .deb nie powiodlo sie'
		sleep 3
		echo $''$(date)'\t\t==>Zakonczono z powodu błedu<==' >> $log
		exit 1	
	fi
	
	mv ./usr/src/linux-source-$nr_kernela2.tar.bz2 linux-source-$nr_kernela2.tar.bz2
	
	if [ $? -eq 1 ]; then
		echo $'Przeniesienie archiwom tar.bz2 nie powiodlo sie'
		sleep 3
		echo $''$(date)'\t\t==>Zakonczono z powodu błedu<==' >> $log
		exit 1	
	fi

	rm -r ./usr
	
	if [ $? -eq 1 ]; then
		echo $'Nie udalo sie skasowac niepotrzebnych folderow i plikow, zrob to recznie'
		sleep 3	
	fi
	
	tar xvf linux-source-$nr_kernela2.tar.bz2 >> $log 2>&1

	if [ $? -eq 1 ]; then
		echo $'Nie udalo sie rozpakowac archiwom tar.bz2'
		sleep 3
		echo $''$(date)'\t\t==>Zakonczono z powodu błedu<==' >> $log
		exit 1	
	fi

	rm linux-source-$nr_kernela2.tar.bz2

	if [ $? -eq 1 ]; then
		echo $'nie udalo sie usunac nie potrzebnego juz archiwom .tar.bz2, zrob to recznie'
		sleep 3	
	fi

	echo $'\nTworzenie miekkiego dowiazania\n'
	ln -s linux-source-$nr_kernela2 linux

	if [ $? -eq 1 ]; then
		echo $'Nie udalo sie stworzyc miekkiego dowiazania!'
		sleep 3
		echo $''$(date)'\t\t==>Zakonczono z powodu błedu<==' >> $log
		exit 1	
	fi

	if [ ! -e linux-source-$nr_kernela2 ]; then
		echo $'\nlinux-source-'$nr_kernela2' nie istnieje'
		blad_przerwanie
		echo $'Nie udalo rozpakowac zrodel\n' >> $log 2>&1
		sleep 3
		echo $''$(date)'\t\t==>Zakonczono z powodu błedu<==' >> $log
		exit 1
	fi
	else
		echo $'\nWykryto istnienie folderu ze zrodlem, \njednak jezeli nie zostal rozpakowany poprawnie skasuj go recznie i powtorz cala operacje.\n Za 5 sekund skrypt ruszy dalej'
		echo "Mozesz przerwac dzialanie skryptu CTRL+C"
		sleep 5
	
fi
}

function kopiowanie_config #CONFIGI
{
if [ -e $sciezka_do_kernela$sciezka/config_backup ]; then
	echo $'Wykryto config_backup, kopiowanie\n'	
	cp ../config_backup .config >> $log 2>&1
	if [ $? -eq 1 ]; then
		echo $'Kopiowanie config_backup zakoncznone niepowodzeniem'
		sleep 3
		echo $''$(date)'\t\t==>Zakonczono z powodu błedu<==' >> $log
		exit 1	
	fi
else	
	if [ ! -e .config ]; then
		echo $'\nKopiowania configow kernela'		
		cp /boot/config-`uname -r` .config >> $log 2>&1
		if [ $? -eq 1 ]; then
			echo $'Kopiowanie .config zakoncznone niepowodzeniem'
			sleep 3
			echo $''$(date)'\t\t==>Zakonczono z powodu błedu<==' >> $log
			exit 1	
		fi
	else
		echo $'\nWykryto istnienie pliku .config, \njednak jezeli to blad lub chcesz zmienic.config przeniesc go w inne miejsce.\n Za 5 sekund skrypt ruszy dalej'
		echo "Mozesz przerwac dzialanie skryptu CTRL+C"
		sleep 5 	
	fi
fi
}

function INSTALACJA
{
if [ $FLAGA_instalacji -eq 1 ]; then
	cd $sciezka_do_kernela$sciezka
	echo $'\n'$(date)'\t\t==>Instaluje '$(date)'<==' >> $log
	if [ $kartaNV -eq 1 ]; then
		echo $"Odinstalowuje nvidia-common"
		sudo apt-get -y purge nvidia-common >> $log 2>&1 #w przypadku kart nv
	fi
	sudo dpkg -i $(ls *$nazwa_kernela*$specjalnaNazwaKernela*.deb) >> $log 2>&1
	if [ $kartaNV -eq 1 ]; then
		echo $"Instaluje nvidia-common"
		sudo apt-get -y install nvidia-common >> $log 2>&1 #w przypadku kart nv
	echo $'\n '$(date)' Zakonczono instalacje!'
	echo $''$(date)'\t\t==>Zakonczono instalacje<==' >> $log
	fi
fi
}

#START
CZYROOT $*
PROMPT_INPUT $*
SPR_FLAGI

echo $''$(date)' Skrypt wystartowal, mozesz anulowac jego dzialanie wciskajac CTRL+C'
#main
tworzenie_logow
echo $''$(date)'\t\t==>START<==' >> $log

if [ $FLAGA_compilacji -eq 1 ]; then
	cd $sciezka_do_kernela$sciezka

	if [ $? -eq 1 ]; then
	echo $'Nie udalo sie wejsc do katalogu:\n '$sciezka_do_kernela$sciezka' ustaw poprawnie uprawnienia!'	
	sleep 5
	fi
	
	echo $'\n'$(date)'\t\t==>Rozpakowywanie zrodel<==' >> $log
	rozpakowywanie_zrodel
	echo $'\n'$(date)'\t\t==>kopiowanie configow <==' >> $log
	cd $sciezka_do_kernela$sciezka/linux 
	kopiowanie_config
	echo $'\nTworzenie menu configuracyjnych\n'
#Polecenia do kompilajci
	make menuconfig
	echo $'\nZa 5 sekund rozpocznie sie procedura kompilacji kernela\n'
	sleep 5
	echo $'\nOdpalam dpkg-clean'
	make-kpkg clean >> $log 2>&1
	echo $'\nkompiluje'
	echo $'\n'$(date)'\t\t==>kompiluje<==' >> $log
	Czas_kom=$(date +%s);
	fakeroot make-kpkg  --initrd --append-to-version=-$nazwa_kernela kernel_image kernel_headers >> $log 2>&1
	Czas_kom=$(expr $(expr $(date +%s) - $Czas_kom) / 60);
	echo $''$(date)'\t\tKompilacja trwala '$Czas_kom' minut<==' >> $log
	echo $'\nKompilacja trwala '$Czas_kom' minut.'
	echo $'Rozpoczynam instalacje nowego kernela za 5 sekund\nMozesz przerwac dzialanie skryptu CTRL+C'
	sleep 5
#Czyszczenie
	CZYSZCZENIE
fi

INSTALACJA

if [ $FLAGA_compilacji -eq 1 ]; then
	Czas=$(expr $(expr $(date +%s) - $Czas) / 60);
	echo $'Zakonczono w '$Czas' minut z czego kompilacja trwala '$Czas_kom' minut!'
	echo $''$(date)'\t\t==>Zakonczono w '$Czas' minut z czego kompilacja trwala '$Czas_kom' minut<==' >> $log
fi

sudo chmod 666 $log

sleep 3
clear
echo $'		[---------------------------------------]'
echo $'		[Author Łukasz Buśko 			]'
echo $'		[Contact buskol.waw.pl@gmail.com	]'
echo $'		[Licens GPL	 			]'
echo $'		[---------------------------------------]'
sleep 10
