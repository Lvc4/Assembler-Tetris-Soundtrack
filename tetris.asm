.text

main:
	#Im Register 4 wird die aktuelle Zeit gezählt
	li a4, 0
	#Die aktuelle Systemzeit wird durch den Systemcall 30 geladen
	li a7, 30
	ecall
	mv t1, a0
#Diese Schleife wird jeden ms genau einmal durchlaufen und muss eventuell einen Ton der beiden Kan le abspielen
loop_start:

	#Aufruf der check_channel Funktion für die Töne von Kanal 1
	li t0, 0
	la a6, channel0_times
	la a0, channel0_notes
	la a1, channel0_lengths
	la a3, channel0_volumes
	li a2, 0
	jal ra, check_channel
	
	#Aufruf der check_channel Funktion för die Töe von Kanal 2
	li t0, 4
	la a6, channel1_times
	la a0, channel1_notes
	la a1, channel1_lengths
	la a3, channel1_volumes
	li a2, 0
	jal ra, check_channel

#Damit die Musik zeitlich richtig abgespielt wird, wird gewartet bis die Systemzeit eine ms fortgeschritten ist. Erst dann wird die Schleife erneut durchlaufen
wait:
    #Laden der aktuellen Systemzeit
	li a7, 30
	ecall
	#Different der aktuellen Systemzeit und der vorherigen Zeit
	sub t2,a0,t1
	#Wenn nicht eine ms vergangen ist wird weiter gewartet
	beq t2, x0, wait
	#Die aktuelle Zeit wird um die Anzahl der verstrichenen ms erh hr
	mv t1, a0
	add a4,a4,t2
	
	#Die Musik endet nach 24024 ms
	li t2, 24024
	bge a4,t2, end
	b loop_start
	
	
#Funktion um einen Kanal auf einen Ton zu Überprüfen und abzuspielen. t0 ist der offset der Tonnummer (channel_ptrs), a6 ist die Adresse des times feld, a0-a3 sind die Adressen der weiteren Felder der Tondaten
check_channel:
    #Zuerst wird Überprüft ob der aktuelle Ton abgespielt werden muss
	#Dazu wird zuerst die Nummer des als n chstes abzuspielenden Tons (channel_ptrs) in a5 geladen
	#%TODO%
	la t4, channel_ptrs
	add t4, t0, t4
	lw a5, 0(t4)
	li t3, 4
	mul t3, t3, a5

	#Anschließend wird die Startzeit des nächsten Ton in a6 geladen
	#%TODO%
	add a6, a6, t3
	lw a6, 0(a6)
	
	#Es wird Überprüft ob die Startzeit in der Zukunft oder Vergangenheit liegt
	bgt a6,a4, continue
		#Die Tonhöhe wird in Register a0 geladen
		#%TODO%
		add a0, a0, t3
		lw a0, 0(a0)
		
		#Die Tonlänge wird in Register a1 geladen
		#%TODO%
		add a1, a1, t3
		lw a1, 0(a1)

		#Die Lautstärke wird in Register a3 geladen
        	#%TODO%
        	add a3, a3, t3
        	lw a3, 0(a3)

		#Der Systemcall zum Abspielen eines Tons (31) wird aufgerufen
		#%TODO%
		li a7, 31
		ecall
		#Die Nummer des als nächstes abzuspielenden Tons wird um 1 erhöht
		addi a5, a5, 1
		sw a5, (t4)
continue:
	jr ra
end:
	li a7, 10
	ecall
	
.data

#In diesen beiden Variablen wird die Nummer des als nächstes abzuspielenden Ton gespeichert
channel_ptrs: 0,0

#Die Musik besteht aus 2 kanälen, die zeitgleich abgespielt werden müssen. times beschreibt die Startzeit für jeden Ton, length die Dauer des Tons, note die Tonhöhe und volume die Lautstärke
channel0_times: 0, 375, 710, 729, 750, 1125, 1500, 1878, 2221, 2240, 2261, 2647, 3037, 3420, 3756, 3774, 3795, 4170, 4545, 4920, 5256, 5274, 5295, 5670, 6045, 6420, 6756, 6774, 6795, 7170, 7545, 7920, 8256, 8274, 8295, 8670, 9006, 9024, 9045, 9420, 9756, 9774, 9795, 10170, 10506, 10524, 10545, 10920, 11256, 11274, 11295, 11670, 12045, 12420, 12795, 13170, 13506, 13524, 13545, 13920, 14295, 14481, 14649, 14670, 15045, 15420, 15795, 17218, 17295, 17670, 18737, 18795, 19170, 19545, 20612, 20670, 21045, 21420, 21756, 21774, 21795, 22170, 22506, 22524, 22545, 22920, 23256, 23274, 23295, 23670, 24006, 24024
channel0_lengths: 562, 503, 29, 31, 562, 562, 567, 514, 28, 31, 579, 585, 574, 504, 28, 31, 562, 562, 562, 504, 28, 31, 562, 562, 562, 504, 28, 31, 562, 562, 562, 504, 28, 31, 562, 504, 28, 31, 562, 504, 28, 31, 562, 504, 28, 31, 562, 504, 28, 31, 562, 562, 562, 562, 562, 504, 28, 31, 562, 562, 279, 253, 31, 562, 562, 562, 0, 115, 562, 0, 87, 562, 562, 0, 87, 562, 562, 504, 28, 31, 562, 504, 28, 31, 562, 504, 28, 31, 562, 504, 28, 0
channel0_notes: 76, 64, 76, 64, 71, 72, 74, 64, 74, 64, 72, 71, 69, 57, 69, 57, 69, 72, 76, 57, 76, 57, 74, 72, 71, 56, 71, 56, 71, 72, 74, 56, 74, 56, 76, 56, 76, 56, 72, 57, 72, 57, 69, 57, 69, 57, 69, 57, 69, 57, 59, 60, 50, 62, 74, 62, 74, 62, 77, 81, 50, 81, 50, 62, 79, 77, 76, 76, 72, 76, 76, 74, 72, 71, 71, 72, 74, 56, 74, 56, 76, 56, 76, 56, 72, 57, 72, 57, 69, 57, 69, 57
channel0_volumes: 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100
channel1_times: 0, 1104, 1125, 1500, 2261, 2647, 3037, 3795, 4170, 4545, 5295, 5670, 6045, 6795, 7170, 7545, 8295, 9045, 9795, 10545, 11295, 11670, 12795, 13545, 13920, 15045, 15420, 15795, 16170, 16545, 16920, 17295, 17670, 18045, 18420, 18795, 19170, 19545, 19920, 20295, 20670, 21045, 21795, 22545, 23295, 24024
channel1_lengths: 0, 31, 562, 0, 579, 585, 0, 562, 562, 0, 562, 562, 0, 562, 562, 0, 1125, 0, 0, 1125, 562, 1687, 0, 562, 1687, 562, 562, 562, 562, 562, 562, 562, 562, 562, 562, 562, 562, 562, 562, 562, 562, 0, 1125, 0, 0, 0
channel1_notes: 52, 52, 64, 52, 52, 64, 45, 45, 57, 45, 45, 57, 44, 44, 56, 44, 44, 45, 45, 45, 47, 48, 50, 50, 62, 50, 62, 48, 60, 48, 60, 48, 60, 48, 60, 48, 60, 44, 56, 44, 56, 44, 44, 45, 45, 0
channel1_volumes: 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 0
