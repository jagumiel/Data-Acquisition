%Graphical transistor comparer

% Inicializing the data acquisition
daqhwinfo ('nidaq');
ai=analoginput('nidaq','Dev1');
ao=analogoutput('nidaq','Dev1');
ic=addchannel(ai,[2 0]); 		% Adding the first two differential
                                % inputs to the input object
ic.inputrange=[0 10];                       % Setting the sensor and input
ic(1).SensorRange=ic(1).InputRange; 		% ranges from 0 to 10 volts
ic(1).UnitsRange=ic(1).InputRange;
ic(1).ChannelName='Drain-Source Voltage';	% Naming channel 2 (1st index)
ic(2).UnitsRange=ic(2).InputRange*10; 		% Measuring current indirectly:
ic(2).SensorRange=ic(2).InputRange; 		% I = V/R, where R is 100? and
ic(2).Units='mA';                       	% 1000 mA = 1 A
ic(2).ChannelName='Drain-Source Current';	% Naming channel 0 (2nd index)
ic
oc=addchannel(ao,[0 1]);                % Adding 2 channels to the output object
oc.UnitsRange=oc(1).OutputRange; 		% The unit range on all channels will
                                        % be the same as the default output
                                        % range (-5V to 5V)
oc(1).ChannelName='Vin';                % Naming the output channels, according
oc(2).ChannelName='Vgs';                % to circuit schematic
oc

% Taking the sample values
Vds=[ ]; 						% Initializing Drain Voltage &
Id=[ ]; 						% Drain to Source Current
VgsList = [-4.5:.5:-2 -1.75:.25:0];
for Vgs = VgsList
	data=[ ];
	for Vin = -5:0.25:5
		putsample(ao,[Vin,Vgs]); 		% Output drain-source, gate voltages
		data=[data; getsample(ai)]; 		% Acquire vector of all inputs
	end 						% for Vgs
	Vds = [Vds data(:,1)]; 				% Setting up voltage matrix
	Id = [Id data(:,2)]; 				% Setting up current matrix
end

% Representing graphical data in 2D plot
h=plot(Vds,Id);
legend(h(5:end),legendStr(5:end));
xlabel('V_{ds} (V)');
ylabel('I_{d} (mA)');
title('\bf{Lines of constant V_{gs} for JFET');

% Representing graphical data in 3D plot
Vgs = repmat(VgsList,[length(Vds(:,1)),1]);
surf(Vds, Vgs, Id); % Plot 3-D surface
xlabel('V_{ds} (V)');
ylabel('V_{gs} (V)');
zlabel('I_{d} (mA)');
title('\bf{Operating Characteristics for JFET}');