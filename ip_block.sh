#!/bin/bash
##Programa de bloqueo de ip
tipo_ip=0
clase=0
maxip=0
minip=0
add=0
port=0
#block_ip(){

#}

baner() {
    clear
    printf "  \e[33;1m     _____________   _________  _  \e[0m\n"
    printf "  \e[33;1m    (____   ______) /  ___   / | |\e[0m\n"
    printf "  \e[33;1m        /  /       /  /__/  /   \ \     \e[0m\n"
    printf "  \e[32;1m       /  /       /  ______/     \ \    \e[0m\n"
    printf "  \e[32;1m      /  /       /  /             \ \   \e[0m\n"
    printf "  \e[31;1m ____/  /____   /  /         ______) )  \e[0m\n"
    printf "  \e[31;1m(____________) /__/         (_______/\e[0m \e[97;1mv.0.1\e[0m\n"
    printf "\n\n"
    printf "  \e[36;1m[\e[0m\e[97;1m1\e[0m\e[36;1m]\e[0m \e[92;1mClase A\e[0m\n"
    printf "  \e[36;1m[\e[0m\e[97;1m2\e[0m\e[36;1m]\e[0m \e[92;1mClase B\e[0m\n"
    printf "  \e[36;1m[\e[0m\e[97;1m3\e[0m\e[36;1m]\e[0m \e[92;1mClase C\e[0m\n"
    printf "  \e[36;1m[\e[0m\e[97;1m4\e[0m\e[36;1m]\e[0m \e[92;1mReglas existentes\e[0m\n"
    printf "  \e[36;1m[\e[0m\e[97;1m5\e[0m\e[36;1m]\e[0m \e[92;1mSalir\e[0m\n\n"
    printf "  \e[95;1mSelecciona una opcion\e[0m\e[97;1m:\e[0m"

    read clase

    select_options
}

select_options() {
    case "$clase" in
    1)
        #CLASE A 1.0.0.0 - 126.0.0.0
        printf "  \e[95;1mAgregar \e[97;1m[S]\e[0m\e[95;1m o Qitar reglas\e[0m\e[97;1m[N]:\e[0m"
        read add

        # printf "  \e[95;1mAgregar puerto a bloquear\e[0m\e[97;1m:\e[0m"
        # read port
        tipo_ip=8
        iniciar_ips
        generar_regla
        ;;
    2)
        #CLASE B
        printf "  \e[95;1mAgregar \e[97;1m[S]\e[0m\e[95;1m o Qitar reglas\e[0m\e[97;1m[N]:\e[0m"
        read add

        # printf "  \e[95;1mAgregar puerto a bloquear\e[0m\e[97;1m:\e[0m"
        # read port
        tipo_ip=16
        iniciar_ips
        generar_regla
        ;;
    3)
        #CLASE C
        printf "  \e[95;1mAgregar \e[97;1m[S]\e[0m\e[95;1m o Qitar reglas\e[0m\e[97;1m[N]:\e[0m"
        read add

        # printf "  \e[95;1mAgregar puerto a bloquear\e[0m\e[97;1m:\e[0m"
        # read port
        tipo_ip=24
        iniciar_ips
        generar_regla
        ;;

    4)
        sudo iptables -nL
        printf "\e[92;1mRegresar al menú: (q)\e[0m\n"
        read aux
        if [ "${aux}" == "q" ] || [ "${aux}" == "Q" ]; then
            baner
        else
            exit 0
        fi
        ;;
    5)
        exit 0
        ;;
    *)
        baner
        ;;
    esac

}

iniciar_ips() {
    printf "  \e[94;1mIp Inicial>>\e[0m"
    read minip
    printf "  \e[94;1mIp Final>>\e[0m"
    read maxip

    validar
}

validar() {
    printf "\e[92;1mValidando Rango de IP...\e[0m\n"
    var=$(ipcalc -c $minip)

    if [[ $var -eq $tipo_ip ]]; then
        printf "\e[92;1mIP $minip valida\e[0m\n"

        var=$(ipcalc -c $maxip)

        if [[ $var -eq $tipo_ip ]]; then
            printf "\e[92;1mIP $maxip valida\e[0m\n"
        else
            printf "\e[91;1mIP $maxip no valida\e[0m\n"
            iniciar_ips
        fi
    else
        printf "\e[91;1mIP $minip no valida\e[0m\n"
        iniciar_ips
    fi
}

generar_regla() {

    printf "\e[92;1mAnalizando IPs...\e[0m\n"
    p1mi=$(echo $minip | cut -d . -f 1)
    p2mi=$(echo $minip | cut -d . -f 2)
    p3mi=$(echo $minip | cut -d . -f 3)
    p4mi=$(echo $minip | cut -d . -f 4)

    printf "\e[92;1m$p1mi.$p2mi.$p3mi.$p4mi\e[0m\n"

    p1ma=$(echo $maxip | cut -d . -f 1)
    p2ma=$(echo $maxip | cut -d . -f 2)
    p3ma=$(echo $maxip | cut -d . -f 3)
    p4ma=$(echo $maxip | cut -d . -f 4)
    printf "\e[92;1m$p1ma.$p2ma.$p3ma.$p4ma\e[0m\n"
    case $tipo_ip in
    8)

        if [ $p1mi -eq $p1ma ]; then
            i=$p2mi
            j=$p3mi
            k=$p4mi
            while         #segundo numero
                while     #tercer numero
                    while #cuarto numero

                        ip_aux="$p1mi.$i.$j.$k"
                        if [ "${add}" == "S" ] || [ "${add}" == "s" ]; then
                            (sudo /sbin/iptables -A INPUT -p tcp -s $ip_aux --dport 22 -j DROP)
                            printf "\e[92;1mAgregando IP...\e[0m"
                        else
                            (sudo /sbin/iptables -D INPUT -p tcp -s $ip_aux --dport 22 -j DROP)
                            printf "\e[92;1mEliminando IP...\e[0m"
                        fi
                        printf "\e[32;1m$ip_aux\e[0m\n"

                        [ $k != $p4ma ]
                    do
                        if [ $k -eq 255 ]; then
                            k=0
                        else
                            k=$(($k + 1))
                        fi
                    done
                    [ $j != $p3ma ]
                do
                    if [ $j -eq 255 ]; then
                        j=0
                    else
                        j=$(($j + 1))
                    fi
                done
                [ $i != $p2ma ]
            do
                i=$(($i + 1))
            done
        else

            printf "\e[91;1mingresa ip de la misma red \e[0m\n"
        fi
        ;;
    16)
        if [ $p1mi -eq $p1ma ] && [ $p2mi -eq $p2ma ]; then
            i=$p2mi
            j=$p3mi
            k=$p4mi
            while     #tercer numero
                while #cuarto numero

                    ip_aux="$p1mi.$i.$j.$k"
                    if [ "${add}" == "S" ] || [ "${add}" == "s" ]; then
                        (sudo /sbin/iptables -A INPUT -p tcp -s $ip_aux --dport 22 -j DROP)
                        printf "\e[92;1mAgregando IP...\e[0m"
                    else
                        (sudo /sbin/iptables -D INPUT -p tcp -s $ip_aux --dport 22 -j DROP)
                        printf "\e[92;1mEliminando IP...\e[0m"
                    fi
                    printf "\e[32;1m$ip_aux\e[0m\n"

                    [ $k != $p4ma ]
                do
                    if [ $k -eq 255 ]; then
                        k=0
                    else
                        k=$(($k + 1))
                    fi
                done
                [ $j != $p3ma ]
            do
                j=$(($j + 1))
            done
        else
            printf "\e[91;1mingresa ip de la misma red \e[0m\n"
        fi
        ;;

    24)
        if [ $p1mi -eq $p1ma ] && [ $p2mi -eq $p2ma ] [ $p3mi -eq $p3ma ]; then
            i=$p2mi
            j=$p3mi
            k=$p4mi
            while #tercer numero
                ip_aux="$p1mi.$i.$j.$k"
                if [ "${add}" == "S" ] || [ "${add}" == "s" ]; then
                    (sudo /sbin/iptables -A INPUT -p tcp -s $ip_aux --dport 22 -j DROP)
                    printf "\e[92;1mAgregando IP...\e[0m"
                else
                    (sudo /sbin/iptables -D INPUT -p tcp -s $ip_aux --dport 22 -j DROP)
                    printf "\e[92;1mEliminando IP...\e[0m"
                fi
                printf "\e[32;1m$ip_aux\e[0m\n"

                [ $k != $p4ma ]
            do
                    k=$(($k + 1))
            done
        else
            printf "\e[91;1mingresa ip de la misma red \e[0m\n"
        fi
        ;;

    esac
    printf "\e[92;1mRegresar al menú: (q)\e[0m\n"
    read aux
    if [ "${aux}" == "q" ] || [ "${aux}" == "Q" ]; then
        baner
    else
        exit 0
    fi
}

clear
baner
