#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <time.h>

#define _CRT_SECURE_NO_WARNINGS // idealne vlozit aj do preprocesora

/* vzor pre "zamestnanci.txt" */
/*Mala Janka
Javorova 75
1
3572.99
20151010
#
Maly Jan
Javorova 75
0
1078.88
20150111
#
Rasusova Martakova Maria
Jiraskova 888/c
0
852.35
20150422
#
Vysoka Maria
Jahodova 587
1
636.90
20090109
#//!!!!! ukoncene bez \n !!!!!!
*/

/* vytvorenie zakladnej struktury */
typedef struct zamestnanci //nazov strukturi zamestnanci
			{
			 	char meno[50];
			 	char bydlisko[50];
			 	char uroven[2];
			 	double plat;
			 	int datum;
				struct zamestnanci *next;
			}ZAMESTNANCI;

/*funkcia na vymazanie celeho zoznamu*/
ZAMESTNANCI *vymaz(ZAMESTNANCI *first)
{
	ZAMESTNANCI *akt, *del;
	
	if (first != NULL) // ak prvy existuje
	{
		akt = first; // tak aktualny je prvy a mozeme maza
		while (akt != NULL)
		{
			del = akt; //del je aktualny
			akt = akt ->next; //aktualny je dalsi ,- pokracuje az do NULL
			free(del); // az kym nebude ,,nic,, tak maz cely zoznam
		}

	}
	
	first = NULL;	// prvy je NULL
	return first; //vratim NULL
}

/*funkcia na nacitanie zoznamu s osetrenim chyby otvorenia*/
ZAMESTNANCI *funkcia_n(ZAMESTNANCI *first)
{
	FILE *fr;
	int a = 0;
	char c;
	ZAMESTNANCI *new_s = NULL, *akt = NULL, *del;
	
	first = vymaz(first); //vymazanie pred nacitanim zoznamu
	
	akt = NULL;
	fr = fopen("zamestnanci.txt", "r");
	if (fr == NULL) //setrenie pre otvorenie suboru
		{
		 	printf("Zaznamy neboli nacitane\n");
		}
	else
		{
			while ((c = fgetc(fr)) != EOF) // inac nacitavaj strukturu az kym nepride end of file
			{
					ungetc(c,fr);
					a++;

					new_s = (ZAMESTNANCI *) malloc(sizeof(ZAMESTNANCI)); //alokacia pamate pre strukturu
					fgets(new_s->meno,50,fr); //postupne prechadzanie celou strukturou
					fgets(new_s->bydlisko,50,fr);
					fgets(new_s->uroven,2,fr);
					fscanf(fr,"%lf",&new_s->plat);
					fscanf(fr,"%d",&new_s->datum);
					fgetc(fr);
					fgetc(fr);
					fgetc(fr); //ak to nieje 3x tak je len ,,ala Janka,, / neviem to urobit cez ungetc()
					new_s->next = NULL;
					

					if (first != NULL) // ak sa prvy nerovna null tak aktualny je novy string
					{
						akt->next = new_s;
						akt = new_s;
					}
					else // inac prvy = aktualny = novy string
					{
						first = akt = new_s;
					}
			}
		}
		printf("Nacitalo sa %d zaznamov\n", a); //oznamenie o pocte nacitanych zaznamov zo zamestnanci.txt
	fclose(fr); //zatvorenie suboru
	return first; //navratova hodnota first (tj. struktury)
}

/*funkcia na vypisanie zoznamu, funkcia vypise cely nacitany zoznam*/
ZAMESTNANCI * funkcia_v(ZAMESTNANCI *first)
{
	int poradie = 0;
	char *nulovy[1],*jednotkovy[1]; //pointer na pole dvoch prvkov (cislo,stringterminator) urcene pre urcenie ,,hodnosti,, zamestnanca
	ZAMESTNANCI *akt = first;
	nulovy[0] = '0'; //expliticne zadanie hodnoty do prveho prvku pola
	jednotkovy[0] = '1'; //expliticne zadanie hodnoty do prveho prvku pola

	while (akt != NULL) //cyklus na vypis zo struktury zamestnanci
	{
		printf("%d.\n", ++poradie); //oddelenie zamestnancov v ciselnom poradi 
		printf("Priezvisko Meno: %s", akt->meno);
		printf("Bydlisko: %s", akt->bydlisko);		
		if(strcmp(akt->uroven,nulovy) == 0) //porovnanie nula a nula / vypis len ked ret ==0
			printf("Bezny Zamestnanec\n");
		else if(strcmp(akt->uroven,jednotkovy) == 0)//porovnanie jedna a jedna // vypis len ked ret ==0
			printf("Riadiaci Zamestnanec\n"); //ked ret < alebo > 0
		else printf("Je zadana zla uroven zamestnanca\n"); //osetrenie pre ine cislo ako 0/1
		printf("Hruba Mzda: %.2lf\n", akt->plat); //vypis na dve desatinne miesta
		printf("Datum vyplaty: %d\n", akt->datum);
		akt=akt->next;
	}
	printf("\n"); //po dokonceni vypisu new line
	return first;
}

/*funkcia na pridanie zaznamu do zoznamu*/ 
ZAMESTNANCI * funkcia_p(ZAMESTNANCI *first)
{
	ZAMESTNANCI *akt, *pom = NULL, *add = NULL, *next = NULL;
	char s_plat[9];
	char s_datum[10];

	add = (ZAMESTNANCI *) malloc(sizeof(ZAMESTNANCI)); //pridanie alokovanim jednej struktury
	getchar();
	printf("Zadaj priezvisko a meno\n");
	gets(add->meno);
	strcat(add->meno,"\n");
	printf("Zadaj adresu bydliska\n");
	gets(add->bydlisko);
	strcat(add->bydlisko,"\n");
	printf("Zadaj poziciu zamestnanca\n");
	gets(add->uroven); 
	printf("Zadaj vysku mzdy\n");
	gets(s_plat);
	add->plat = atoi(s_plat); //konvertuj char konstantu na integer
	printf("Zadaj datum vyplaty\n");
	gets(s_datum);
	add->datum = atoi(s_datum); //konvertuj char konstantu na integer
	add->next = NULL;

	/*zoradovanie do zoznamu podla mena*/

	if (first == NULL) //  ak nie je nic ine tak pridany je prvy
	{
		first = add; 
		return first;
	}
	else
	{
		akt = first; // prvy je pridany
		while (akt->next != NULL)
		{
			if (strcmp(add->meno,first->meno) < 0) //ak  pridany je mensi ako prvy
			{
				add->next = first; //prvy je dalsi
				first = add;//pridany je prvy
				return first;
			}
			if ((strcmp(add->meno,akt->meno) >= 0) && (strcmp(add->meno,akt->next->meno) <=0 ) && (akt->next != NULL)) //ak pridany je vacsi alebo rovny aktualnemu a zaroven pridany je mensi alebo rovny dalsiemu a zaroven pridany je mensi alebo rovnaky dalsiemu
				{				
					pom=akt->next;
					akt->next=add;
					add->next=pom;
					return first;
				}

			akt = akt->next;		
		}
	
		if ((akt->next == NULL) && strcmp(add->meno,akt->meno) >= 0) //ak dalsi nieje a zaroven pridany je vacsi alebo rovny aktualnemu
		{
			akt->next = add;
			akt = add;
			return first;
		}
		if ((akt->next == NULL) && strcmp(add->meno,akt->meno) <= 0) //ak dalsi nieje a zaroven pridany je mensi alebo rovny aktualnemu
		{
			add->next = akt;
			first = add;
			return first;
		}
	}
}

/*funkcia na hladanie podla mena z hladacom medzier (priezvisko(medzera)meno)*/
ZAMESTNANCI * funkcia_h(ZAMESTNANCI *first)
{
	ZAMESTNANCI *akt = first;
	char porovnaj[50], *meno,*nulovy[1], *jednotkovy[1];
	int match = 1 , i, medzera, poz = 0, j = 0 ;
	nulovy[0] = '0';
	jednotkovy[0] = '1';

	getchar();
	printf("Zadaj meno hladaneho/nej \n");
	gets(porovnaj);//nacitaj hladane priezvisko/meno

	akt = first;
	meno = (char*) malloc ((strlen(porovnaj) + 1)*sizeof(char*)); //+1 pre NULL terminate condition

	while (akt != NULL)
	{
		for (i = 0; i < strlen(akt->meno); i++)
		{
			if (akt->meno[i] == ' ')
				medzera = i;
		}
		j = 0;
		for (i = medzera + 1; i<strlen(akt->meno); i++)
		{
			meno[j] = akt->meno[i];
			j++;
		}
		meno[j] = '\0';

		if ((strstr(meno,porovnaj) != NULL) && (strlen(meno)-1 == strlen(porovnaj))) //ak porovnavany(substring) existuje v ramci meno a zaroven dlzka meno-1 je rovnaka ako porovnaj tak vypis strukturu
		{
			printf("%d.\n",match);
			printf("Priezvisko Meno: %s", akt->meno);
			printf("Bydlisko: %s", akt->bydlisko);		
			if(strcmp(akt->uroven,nulovy) == 0)
				printf("Bezny Zamestnanec\n");
			else if(strcmp(akt->uroven,jednotkovy) == 0)
				printf("Riadiaci Zamestnanec\n");
			else printf("Je zadana zla uroven zamestnanca\n");
			printf("Hruba Mzda: %.2lf\n", akt->plat);
			printf("Datum vyplaty: %d\n", akt->datum);
			match++;
		}

		akt=akt->next;
	}
	if(match == 1) //ak sa nenaslo nic
	{
		printf("Nenasiel sa ziadny zaznam s hladanym menom\n");
	}
	return first;
}

/*funkcia na aktualizovanie vsetkych platov pod zadanu sumu podla novo zadanej minimalnej mzdy*/
ZAMESTNANCI *funkcia_a(ZAMESTNANCI *first)
{
	ZAMESTNANCI *akt;
	int i = 0, prepisane = 0, pom = 0; //pom je obdoba pocitacky(a) z *funkcia_n
	double m = 0; //pre novo nacitanu minimalnu mzdu
	char c;
	FILE *fr;
	
	fr = fopen("zamestnanci.txt", "r");
	scanf("%lf",&m);
	while ((c=fgetc(fr)) != EOF)
	{
		if(c == '#') //pocitadlo zaznamov v strukture
			pom++;
	}
	rewind(fr);
	akt = first;
	if (first == NULL) //ak zoznam neexistuje 
	{
		printf("Zoznam sa neaktualizoval\n");
		return first;
	}
	else //inac prepisuj ,,plat,,
	{
		for(i = 0;i < pom; i++)
		{
			if(akt->plat < m) // ak zaznam je mensi ako zadana hodnota novej mzdy
			{
				akt->plat = m; //aktualny zaznam == m
				prepisane++; //pridanie do poctu prepisanych zaznamov
			}
			akt = akt->next; //aktualny do dalsieho pre prejdenie zoznamu
		}
		printf("Bolo aktualizovanych %d zaznamov\n", prepisane); //pocet prepisanych zaznamov zo zoznamu
		return first;
	}

	return first;
}

/*funkcia help pre zobrazenie pomocneho menu*/
/*void help()
{
	printf("Stlac 'n' pre nacitanie struktury zo >zamestnanci.txt<\n");
	printf("Stlac 'v' pre vypisanie struktury zo >zamestnanci.txt<\n");
	printf("Stlac 'p' pre pridanie zaznamu do nacitanej struktury\n");
	printf("Stlac 'h' pre vyhladanie zamestnanca podla priezviska\n");
	printf("Stlac 'a' pre zmenu minimalneho platu zamestnanca v celej strukture\n");
	printf("Stlac 'k' pre pre ukoncenie programu\n");
	
	//return 0;
}*/

/*hlavná funkcia podla toho ake pismeno stlacim tak sa vykona taka funkcia po zadani k sa program skonci*/
int main()
{
	char c;
	ZAMESTNANCI *FIRST = NULL;
	int opakovat = 1; // pre vytvorenie nekonecneho cyklu v switchi
	time_t current_time;
    char* c_time_string;
    current_time = time(NULL);
    c_time_string = ctime(&current_time);
    (void) printf("Program spusteny %s", c_time_string);
	printf("Miroslav Kuchar // xkucharm1@is.stuba.sk // 1. Semestralna praca\n");
	//printf("Stlac 'x' pre zobrazenie menu\n"); //raz to opravim !

	do
	{
		switch(c = getchar())
		{
			case 'n' : FIRST = funkcia_n(FIRST); break; //nacitanie struktury
			case 'N' : FIRST = funkcia_n(FIRST); break; //nacitanie struktury / setrenie pre Upper Case
			case 'v' : FIRST = funkcia_v(FIRST); break; //vypisanie struktury
			case 'V' : FIRST = funkcia_v(FIRST); break; //vypisanie struktury / setrenie pre Upper Case
			case 'p' : FIRST = funkcia_p(FIRST); break; //pridanie struktury
			case 'P' : FIRST = funkcia_p(FIRST); break; //pridanie struktury / setrenie pre Upper Case
			case 'h' : if (FIRST != NULL) FIRST = funkcia_h(FIRST); break; //vyhladanie zamestnanca podla priezviska
			case 'H' : if (FIRST != NULL) FIRST = funkcia_h(FIRST); break; //vyhladanie zamestnanca podla priezviska / setrenie pre Upper Case
			case 'a' : if (FIRST != NULL) FIRST = funkcia_a(FIRST); break; //aktualizovanie minimalnej mzdy
			case 'A' : if (FIRST != NULL) FIRST = funkcia_a(FIRST); break; //aktualizovanie minimalnej mzdy / setrenie pre Upper Case
			//case 'x' : help; break; //zobrazenie pomocneho menu
			case 'k' : opakovat = 0; FIRST = vymaz(FIRST); break; //ukoncenie programu
			case 'K' : opakovat = 0; FIRST = vymaz(FIRST); break; //ukoncenie programu / setrenie pre Upper Case
		}
	} while (opakovat);
			
	return 0;
	system("pause"); //systemove zastavenie vypnutia programu (press any key to continue..)
}