#!/bin/bash

baner() {
    clear
    echo
    printf "\e[92:1m  ███╗   ███╗███████╗███╗   ██╗██╗   ██╗      ██╗██████╗  \e[0m\n"
    printf "\e[92:1m  ████╗ ████║██╔════╝████╗  ██║██║   ██║      ██║██╔══██╗ \e[0m\n"
    printf "\e[92:1m  ██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║█████╗██║██████╔╝ \e[0m\n"
    printf "\e[92:1m  ██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║╚════╝██║██╔═══╝  \e[0m\n"
    printf "\e[92:1m  ██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝      ██║██║      \e[0m\n"
    printf "\e[92:1m  ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝       ╚═╝╚═╝\e[0m \e[1mv 0.1\e[0m\n"
}

menu() {
    echo ""
    echo -e "  \e[96;1m[\e[0m\e[93;1m1\e[0m\e[96;1m]\e[0m\e[32;1m Detener firewall\e[0m"
    echo -e "  \e[96;1m[\e[0m\e[93;1m2\e[0m\e[96;1m]\e[0m\e[32;1m Inicializar iptables\e[0m"
    echo -e "  \e[96;1m[\e[0m\e[93;1m3\e[0m\e[96;1m]\e[0m\e[32;1m Dropear ping remoto\e[0m"
    echo -e "  \e[96;1m[\e[0m\e[93;1m4\e[0m\e[96;1m]\e[0m\e[32;1m Desbloquear ping remoto\e[0m"
    echo -e "  \e[96;1m[\e[0m\e[93;1m5\e[0m\e[96;1m]\e[0m\e[32;1m Bloquear puerto 22 por IP\e[0m"
    echo -e "  \e[96;1m[\e[0m\e[93;1m6\e[0m\e[96;1m]\e[0m\e[32;1m Desbloquear puerto 22 por IP\e[0m"
    echo -e "  \e[96;1m[\e[0m\e[93;1m7\e[0m\e[96;1m]\e[0m\e[32;1m Bloquear puerto 22 por MAC\e[0m"
    echo -e "  \e[96;1m[\e[0m\e[93;1m8\e[0m\e[96;1m]\e[0m\e[32;1m Desbloquear puerto 22 por MAC\e[0m"
    echo -e "  \e[96;1m[\e[0m\e[93;1m9\e[0m\e[96;1m]\e[0m\e[32;1m Ver reglas existentes\e[0m"
    echo -e "  \e[96;1m[\e[0m\e[93;1m10\e[0m\e[96;1m]\e[0m\e[32;1m Salir\e[0m"
}

Opciones_de_menu() {
    case $option in
    1) # detener firewall
        sudo systemctl stop firewalld
        inicio
        ;;
    2) # iniciar servicio de iptables
        sudo systemctl start iptables.service
        echo listo
        inicio
        ;;
    3) #Dropear ip
        inter_ip
        pregunta_exit
        ;;
    4) #agregar ip
        inter_ip
        pregunta_exit
        ;;
    5) #dropear por puerto 22
        inter_port
        pregunta_exit
        ;;
    6) # agregar por puerto 22
        inter_port
        pregunta_exit
        ;;
    7) #agregar por mac
        inter_MAC
        pregunta_exit
        ;;
    8) #eliminar por mac
        inter_MAC
        pregunta_exit
        ;;
    9) # ver las reglas de iptables
        printf "\e[95m $(sudo iptables -nL)\e[0m"
        pregunta_exit
        ;;
    10) #salir
        exit 0
        ;;
    *) # otros
        inicio
        ;;
    esac
}
ip = 0
iniciar_ip() {
    if [ $option -eq 3 ] || [ $option -eq 5 ]; then
        printf "\e[32;1mIngresa ip a bloquear: \e[0m"
    else
        printf "\e[32;1mIngresa ip a desbloquear: \e[0m"
    fi
    read ip
}

iniciar_MAC() {
    if [ $option -eq 7 ]; then
        printf "\e[32;1mIngresa la direccion MAC a bloquear: \e[0m"
    else
        printf "\e[32;1mIngresa la direccion MAC a desbloquear: \e[0m"
    fi
    read ip
}
inter_ip() {
    iniciar_ip
    dropear_ip
}

inter_port() {
    iniciar_ip
    dropear_puerto
}
inter_MAC() {
    iniciar_MAC
    dropear_MAC
}

dropear_MAC() {
    if [ $option -eq 7 ]; then
        printf "\e[92;1mAgregando MAC...\e[0m"
        sudo /sbin/iptables -A INPUT -p tcp --dport 22 -m mac --mac-s $ip -j DROP
    else
        printf "\e[92;1mEliminando MAC...\e[0m"
        sudo /sbin/iptables -D INPUT -p tcp --dport 22 -m mac --mac-s $ip -j DROP
    fi
    printf "\e[92;1m$ip\e[0m\n"
}

dropear_puerto() {
    printf "\e[92;1mValidando IP...\e[0m\n"
    var=$(ipcalc -c $ip)
    if [ $var -eq 8 ] || [ $var -eq 16 ] || [ $var -eq 24 ]; then
        printf "\e[32;1mIP $ip valida\e[0m\n"
        if [ $option -eq 5 ]; then
            printf "\e[92;1mAgregando IP...\e[0m"
            sudo /sbin/iptables -A INPUT -p tcp -s $ip --dport 22 -j DROP
        else
            printf "\e[92;1mEliminando IP...\e[0m"
            sudo /sbin/iptables -D INPUT -p tcp -s $ip --dport 22 -j DROP
        fi
        printf "\e[92;1m$ip\e[0m\n"
    else
        printf "\e[91;1mIP $ip no valida\e[0m\n"
        inter_port
    fi
}

dropear_ip() {
    printf "\e[92;1mValidando IP...\e[0m\n"
    var=$(ipcalc -c $ip)
    if [ $var -eq 8 ] || [ $var -eq 16 ] || [ $var -eq 24 ]; then
        printf "\e[32;1mIP $ip valida\e[0m\n"
        if [ $option -eq 3 ]; then
            printf "\e[92;1mAgregando IP...\e[0m"
            sudo /sbin/iptables -A INPUT -p tcp -s $ip -j DROP
        else
            printf "\e[92;1mEliminando IP...\e[0m"
            sudo /sbin/iptables -D INPUT -p tcp -s $ip -j DROP
        fi
        printf "\e[92;1m$ip\e[0m\n"
    else
        printf "\e[91;1mIP $ip no valida\e[0m\n"
        inter_ip
    fi
}

pregunta_exit() {
    printf "\n\n\e[92;1mRegresar al menú: (q)\e[0m\n"
    read aux
    if [ "${aux}" == "q" ] || [ "${aux}" == "Q" ]; then
        inicio
    else
        exit 0
    fi
}
inicio() {
    baner
    menu
    printf "\e[32;1mSeleccione opcion del menú: \e[0m"
    read option
    Opciones_de_menu
}
inicio
