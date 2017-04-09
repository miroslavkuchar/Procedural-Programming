import socket
import time

def suma(cislo):
    a = 0
    b = 0
    while b < cislo:
        a = a + cislo
        cislo = cislo - 1
    return a 

if raw_input("Chcete byt client?(ano/nie)") == "ano":
    
    UDP_IP = raw_input("Zadaj IP(127.0.0.1 - pre local): ")
    UDP_PORT = 5005
    buflen = raw_input("Zadaj dlzku fragmentu(min: 4, max: 65532): ")
    #65535
    print "Cielova IP: ", UDP_IP
    print "Cielovy port: ", UDP_PORT
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.sendto(buflen, (UDP_IP, UDP_PORT))
    
    while True:
        sprava = raw_input("Zadaj spravu: ")
        x = len(sprava)
        i = 1
        ack = 9
        if x % (int(buflen)-3) == 0:
            pocet_f = x / (int(buflen)-3)
        else:
            pocet_f = (x / (int(buflen)-3)) + 1
        temp = 0
        while x+pocet_f+i+i > int(buflen):
            pom = str(pocet_f) + str(i) + str(ack) + sprava[int(temp):(int(buflen)+int(temp)-3)]
            temp = int(buflen) + int(temp) - 3
            sock.sendto(pom, (UDP_IP, UDP_PORT))
            back, adr = sock.recvfrom(int(buflen))
            if back == "NO":
                print back
                print "Odosielam znova %d. fragment" % i
                sock.sendto(pom, (UDP_IP, UDP_PORT))
                exit
            elif back == "OK":
                print back
            else:
                print "Nedostal som odpoved"
                time.sleep(2)
                exit
            i = i + 1
            x = x - int(buflen)
        else:
            if temp == 0:
                pom = str(pocet_f) + str(i) + str(ack) + sprava[(int(temp)):(len(sprava))]
                #i = i + 1
            else:
                pom = str(pocet_f) + str(i) + str(ack) + sprava[(int(temp)):(len(sprava))]
                #i = i + 1
            sock.sendto(pom, (UDP_IP, UDP_PORT))
            back, adr = sock.recvfrom(int(buflen))
            if back == "NO":
                print back
                print "Odosielam znova %d. fragment" % i
                sock.sendto(pom, (UDP_IP, UDP_PORT))
                exit
            elif back == "OK":
                print back
            else:
                print "Nedostal som odpoved"
                time.sleep(2)
                exit
        print "Odoslana sprava: ", sprava

    print "skoncil som"
    time.sleep(5)

if raw_input("Chcete byt server?(ano/nie)") == "ano":
    UDP_IP = "0.0.0.0"
    UDP_PORT = 5005
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((UDP_IP, UDP_PORT))
    buflen, addr = sock.recvfrom(100)
    count = 0
    vypis = ""
    zle = "" 
    sum_d1 = 0
    sum_f = 0
    reply_o = "OK"
    reply_n = "NO"
    while True:
        data, addr = sock.recvfrom(int(buflen))
        if data[2] == "9":
            sock.sendto(reply_o, addr)
            print "Bola zaslana sprava 'OK'"
        else:
            sock.sendto(reply_n, addr)
            print "Bola zaslana sprava 'NO'"
            data, addr = sock.recvfrom(int(buflen))
            if data[2] != "9":
                print "Chyba"
                time.sleep(2)
                exit
        count = count + 1
        if data[1] == str(count):
            vypis = vypis + data[3:]
            sum_d1 = sum_d1 + int(data[1])
            zle = zle + data
        else:
            zle = zle + data 
        while count < int(data[0]):
            data, addr = sock.recvfrom(int(buflen))
            if data[2] == "9":
                sock.sendto(reply_o, addr)
                print "Bola zaslana sprava 'OK'"
            else:
                sock.sendto(reply_n, addr)
                print "Bola zaslana sprava 'NO'"
                data, addr = sock.recvfrom(int(buflen))
                if data[2] != "9":
                    print "Chyba"
                    time.sleep(2)
                    exit
            count = count + 1
            #print "count je: ", count
            if data[1] == str(count):
                vypis = vypis + data[3:]
                sum_d1 = sum_d1 + int(data[1])
                zle = zle + data
            else:
                zle = zle + data
        #print "count je: %d" %count
        sum_f = suma(int(data[0]))
        #print "suma je: ", sum_f
        print "Chyba, sprava neprisla v poriadku ... ", zle
        zle_dlzka = len(zle)
        ind = 1
        poradie = 1
        dobre = ""
        vsetky = int(zle[0])
        while poradie <= vsetky:
            if (ind+9) > zle_dlzka:
                dobre = dobre + zle[ind+2:zle_dlzka]
            else: #int(zle[ind]) == poradie:
                dobre = dobre + zle[ind+2:ind+9]
                ind = ind + 10
            poradie = poradie + 1
            print "HELP ME"
        print "Sprava po oprave: ", dobre
        count = 0
        vypis = ""
        sum_d1 = 0
        sum_f = 0
        zle = ""
        """if count == int(data[0]) and sum_f == sum_d1:
            print "Sprava ma %d fragmentov" % int(data[0])
            print "Sprava:", vypis
            count = 0
            vypis = ""
            sum_d1 = 0
            sum_f = 0
            zle = ""
        else:
            print "Chyba, sprava neprisla v poriadku ... ", zle
            zle_dlzka = len(zle)
            ind = 1
            poradie = 1
            dobre = ""
            vsetky = int(zle[0])
            while poradie < vsetky:
                if int(zle[ind]) == poradie:
                    if (ind+9) > zle_dlzka:
                        dobre = dobre + zle[ind+2:zle_dlzka]
                    dobre = dobre + zle[ind+2:ind+9]
                    ind = ind + 10
                else:
                    ind = 1
                    poradie = poradie + 1
            print "Sprava po oprave: ", dobre
            count = 0
            vypis = ""
            sum_d1 = 0
            sum_f = 0
            zle = "" """
else:
    print("zly vstup")
print "skoncil som"
time.sleep(5)
