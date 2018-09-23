:- dynamic say_hi.
:- dynamic read_theif1.
:- dynamic read_police.
:- dynamic wall_status/2.
:- dynamic address

% input address of file and start moving against the direction of robot1
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
	ss.


ss:-
	assert(wall_status(WS,0)),		% to check whether goint outside of boundary
	start.

start:-
	assert(result(List1,[])),
	result(List1,X),
	write(X),
	read_theif1,					% reading coordinates of robot2
	result(List1,M),
	write(M),nl,nl,
	nth1(1,M,X2),
	nth1(2,M,Y2),
	
	retract(result(List1,M)),
	

	assert(result(List2,[])),
	result(List2,P),
	write(P),
	read_police,					% reading coordinates of robot1
	result(List2,Q),
	write(Q),

	
	
	nth1(2,Q,Y1),
	nth1(1,Q,X1),
	retract(result(List2,Q)),

	
	D is sqrt((X2-X1)^2 + (Y2-Y1)^2),		% calculation for distance
	write('Distance is '),
	write(D),nl,nl,

	assert(val(M,0)),
	val(M,Some),
	Z is atan((Y2-Y1)/(X2-X1))*(180/3.141),
	retract(val(M,Some)),
	assert(val(M,Z)),
	val(M,Temp_Angle),
	write('Angle is '),
	write(Temp_Angle),nl,nl,


	% calculation of angle between robot1 and robot2

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


	

	init_compass_nxt('ZAPS',1),
	read_compass_nxt('ZAPS',1,Mag),
	Angle is Final,
	Temp_comp is (Mag+170),
	Comp is mod(Temp_comp,360),nl,nl,
	write('after calc '),
	write(Comp),nl,nl,

	wall_status(WS,Wall_Touch),



	( 
		(D > 250) ->					% if police is outside
			(
				%rotate_nxt %
				move_forward_nxt('ZAPS','B',180),
				move_backward_nxt('ZAPS','C',180),

				write('some')
			);

			(	
				write(''),
				stop_nxt('ZAPS','B','C'),						% else
				(D > 80.0) ->			% if police is inside vision
					(

						write(' do some calculation to find wall is here and make WALL is 1'),nl,
						write('value of y2 is '),
						write(Y2),nl,

						(Y2 =< 60) ->			% if left wall detected
							(
								( Angle > 180, Angle < 270) ->			% if moving downside
									(
										W is (Comp-180)*(5.89),
										Xe is round(W),
										write('rotate by 1 '),
										write(Xe),nl,
										rotate_nxt('ZAPS','B',Xe,'A'),
										write('follwoing wall downside'),
										move_forward_nxt('ZAPS','B','C',180),
										sleep(1),
										stop_nxt('ZAPS','B','C'),
										retract(wall_status(WS,Wall_Touch)),
										assert(wall_status(WS,1))


									);

									(									% else moving upside
										W is (360-Comp)*(5.89),
										Xe is round(W),
										write('rotate by 1 '),
										write(Xe),nl,
										rotate_nxt('ZAPS','B',Xe,'C'),
										write('follwoing wall upside'),
										move_forward_nxt('ZAPS','B','C',180),
										sleep(1),
										stop_nxt('ZAPS','B','C'),
										retract(wall_status(WS,Wall_Touch)),
										assert(wall_status(WS,1))


									)
																

							);



							(						% else move opposite to police
								
								write('move opposite to police'),
								

								

								write('Angle is '),
								write(Angle),nl,
								write('Comp value is '),
								write(Comp),nl,
								

								
								(Comp-Angle)>0 ->
									((Comp-Angle)<180 ->
										W is (180-(Comp-Angle))*(5.89),
										Xe is round(W),
										write('rotate by 1 '),
										write(Xe),nl,
										rotate_nxt('ZAPS','B',Xe,'C');


										W is (Comp-180-Angle)*(5.89),
										Xe is round(W),
										write('rotate by 2 '),
										write(Xe),nl,
										rotate_nxt('ZAPS','B',Xe,'A')


									);
									((Comp-Angle)> (-180) ->
										W is (180-(Angle-Comp))*(5.89),
										Xe is round(W),
										write('rotate by 3 '),
										write(Xe),nl,
										rotate_nxt('ZAPS','B',Xe,'A');

										W is (Angle - 180 - Comp)*(5.89),
										Xe is round(W),
										write('rotate by 4 '),
										write(Xe),nl,
										rotate_nxt('ZAPS','B',Xe,'C')
									)

								

							),

							move_forward_nxt('ZAPS','B','C',180),
							sleep(1),
							stop_nxt('ZAPS','B','C')


					);


					(
						nl,nl,
						(Angle > 160, Angle < 200, X2 =< 60) ->
							W is (Comp-90)*(5.89),
							Xe is round(W),
							write('first line follow ******************** '),
							write(Xe),nl,
							rotate_nxt('ZAPS','B',Xe,'A'),
							move_forward_nxt('ZAPS','B','C',180),
							sleep(1),
							stop_nxt('ZAPS','B','C');
						
						(Angle > 70, Angle < 110, Y2 =< 400) ->
							W is (Comp-90)*(5.89),
							Xe is round(W),
							write('2nd line follow ********************'),
							write(Xe),nl,
							rotate_nxt('ZAPS','B',Xe,'A'),
							move_forward_nxt('ZAPS','B','C',180),
							sleep(1),
							stop_nxt('ZAPS','B','C');

						(Angle > 340, Angle < 20, X2 >= 570) ->
							W is (90)*(5.89),
							Xe is round(W),
							write('3rd line follow ********************'),
							write(Xe),nl,
							rotate_nxt('ZAPS','B',Xe,'A'),
							move_forward_nxt('ZAPS','B','C',180),
							sleep(1),
							stop_nxt('ZAPS','B','C');

						(Angle > 250, Angle < 290, Y2 =< 60) ->
							W is (Comp-180)*(5.89),
							Xe is round(W),
							write('4th line follow ********************'),
							write(Xe),nl,
							rotate_nxt('ZAPS','B',Xe,'A'),
							move_forward_nxt('ZAPS','B','C',180),
							sleep(1),
							stop_nxt('ZAPS','B','C');


							write('Wall_Touch is one'),nl


					)
			)


	),

	write('distance is '),
	write(D),
	(
		(D < 80 ) ->			% if distance between robot1 and robot2 is less than 80 it will stop

		(
			stop_nxt('green','B','C'),
			write('theif1 will die')
		);

		(
			write('')
		)

	),

	(D < 80 ) ->

		(
			stop_nxt('some_other','B','C'),
			write('theif1 will die')
		);

		(
			write('theif1 will die')
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

read_theif1:-
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