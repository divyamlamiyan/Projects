:- dynamic say_hi.
:- dynamic read_police.
:- dynamic read_theif.
:- dynamic address.


address:-
	write('Enter Address of first file'),nl,
	read(I),
	write('Enter Address of second file'),nl,
	read(J),
	assert(add1(Add1,I)),
	assert(add2(Add2,J)),
	write('inside address '),
	add1(Add1,XYZ),
	write(XYZ),nl,nl,
	start.

start:-
	assert(result(List1,[])),
	result(List1,X),
	write(X),
	read_police,						% read file to get coordinate of robot1
	result(List1,M),
	write(M),nl,nl,
	nth1(1,M,X2),
	nth1(2,M,Y2),
	
	retract(result(List1,M)),
	

	assert(result(List2,[])),
	result(List2,P),
	write(P),
	read_theif,							% read file to get coordinate of robot2
	result(List2,Q),
	write(Q),

	
	
	nth1(2,Q,Y1),
	nth1(1,Q,X1),
	retract(result(List2,Q)),

	
	D is sqrt((X2-X1)^2 + (Y2-Y1)^2),	% calculation to find distance between robots
	write('Distance is '),
	write(D),nl,nl,



	assert(val(M,0)),
	val(M,Some),
	Z is atan((Y2-Y1)/(X2-X1))*(180/3.141),
	retract(val(M,Some)),
	assert(val(M,Z)),
	val(M,Temp_Angle),
	write('Angle before cordinates is '),
	write(Temp_Angle),nl,nl,

	% calculation of angle between robots

	(
	(X2-X1)<0 -> 
		((Y2-Y1)>0 ->

			write('x <0  and y>0 : 2nd qurd'),
			val(M,Xx),

			Temp is (Xx+360),

			retract(val(M,Xx)),
			assert(val(M,Temp));


			write('third')

		);

		((Y2-Y1)<0 ->
			write('x>0 and y < 0 : 4th  '),
			val(M,Xx),
			Temp is (Xx+180),

			retract(val(M,Xx)),
			assert(val(M,Temp));

			write('X >0  AND ' ),

			write('Y > 0 : 1st '),
			val(M,Xx),
			Temp is (Xx+180),

			retract(val(M,Xx)),
			assert(val(M,Temp))
		)
	),
	write(''),nl,nl,nl,
	write('Final value of angle is '),
	val(M,Final),
	write(Final),
	retract(val(M,Final)),
	nl,nl,nl,nl,





	

	init_compass_nxt('green',1),
	read_compass_nxt('green',1,Mag),
	write('Mag value is '),
	write(Mag),nl,nl,
	Angle is Final,
	Temp_comp is (Mag+170),
	Comp is mod(Temp_comp,360),nl,nl,
	write('after calc '),
	write(Comp),nl,nl,
	
	% calculation of angle wrt compass

	(
		(Comp-Angle)>0 ->
			((Comp-Angle)<180 ->
				W is (Comp-Angle)*(5.89),
				Xe is round(W),
				write('rotate by 1 '),
				write(Xe),nl,
				rotate_nxt('green','B',Xe,'A');


				W is ((360-Comp)+Angle)*(5.89),
				Xe is round(W),
				write('rotate by 2 '),
				write(Xe),nl,
				rotate_nxt('green','B',Xe,'C')


			);
			((Comp-Angle)> (-180) ->
				W is (Angle-Comp)*(5.89),
				Xe is round(W),
				write('rotate by 3 '),
				write(Xe),nl,
				rotate_nxt('green','B',Xe,'C');

				W is ((360-Angle)+Comp)*(5.89),
				Xe is round(W),
				write('rotate by 4 '),
				write(Xe),nl,
				rotate_nxt('green','B',Xe,'A')
			)

		
	),


	move_forward_nxt('green','B','C',250),
	sleep(1),
	stop_nxt('green','B','C'),

	write('distance is '),
	write(D),

	(
		(D < 80 ) ->

		(
			stop_nxt('ZAPS','B','C'),
			stop_nxt('prasanta roy','B','C'),
			write('theif1 will die')
		);

		(
			write('faltu kaam')
		)

	),
	
	start.




	


read_police:-
	add1(Add1,I),
	write('inside police '),
	write(I),
	open(I, read, Str),
	read(Str,B), 
	read(Str,C), 
	close(Str),
	result(List1,Y),
	append(Y,[B,C],Z), 
	retract(result(List1,Y)),
	assert(result(List1,Z)).

read_theif:-
	add2(Add2,J),
	write(J),
	open(J, read, Str),
	read(Str,E), 
	read(Str,F), 
	close(Str),
	result(List2,Y),
	append(Y,[E,F],Z), 
	retract(result(List2,Y)),
	assert(result(List2,Z)).