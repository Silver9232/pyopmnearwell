"""Set the full path to the flow executable and flags"""
${flow} --enable-tuning=true --enable-opm-rst-file=true --linear-solver=cprw

"""Set the model parameters"""
h2storegaussian #Model (co2store/h2store)
cake 36  #Grid type (radial/cake/cartesian2d/cartesian) and size (theta[in degrees]/theta[in degrees]/width[m]/anynumber(the y size is set equal to the x one))
2500 100     #Reservoir dimensions [m] (Lenght and height)
100 10 3      #Number of x- and z-cells [-] and exponential factor for the telescopic x-gridding (0 to use an equidistance partition)
0.25 0 0     #Well diameter [m] and well transmiscibility (0 to use the computed one internally in Flow)
4e6 50 0     #Pressure [Pa] on the top and uniform temperature [°] (!!!!!!!Currently only for these pressure and temperature values, it is in the TODO list to extend this)
1e4          #Pore volume multiplier on the boundary [-] (0 to use well producers instead)[-]
0 5 15       #Activate perforations [-], number of well perforations [-], and lenght [m]
4 0 ${econ}  #Number of layers [-], hysteresis (1 to activate), and econ for the producer (for h2 models)
0 0 0        #Initial salt concentrationn [kg/m3], salt solubility limit [kg/m3], and precipitated salt density [kg/m3] (for saltprec)
300-300*mt.exp(-(x**2)/(2*500**2)) - 0*100*mt.exp(-((x-500)**2)/(2*100**2)) #The function for the reservoir surface

"""Set the saturation functions"""
krw * ((sw - swi) / (1.0 - sni -swi)) ** nkrw             #Wetting rel perm saturation function [-]
krn * ((1.0 - sw - sni) / (1.0 - sni - swi)) ** nkrn      #Non-wetting rel perm saturation function [-]
pec * ((sw - swi) / (1.0 - sni - swi)) ** (-(1.0 / npe)) #Capillary pressure saturation function [Pa]

"""Properties saturation functions"""
"""swi [-], sni [-], krn [-], krw [-], pec [Pa], nkrw [-], nkrn [-], npe [-], threshold cP evaluation, ignore swi for cP"""
SWI3  0.1 SNI3  0.1 KRW3  .8 KRN3  .2 PRE3  .4e6 NKRW3 4 NKRN3 3.5 HNPE3 1.2 THRE3  1e-4 IGN1 0
SWI4  0.1 SNI4  0.1 KRW4  .8 KRN4  .2 PRE4   4e6 NKRW4 4 NKRN3 3.5 HNPE4 1.2 THRE4  1e-4 IGN1 0
SWI5  0.1 SNI5  0.1 KRW5  .8 KRN5  .2 PRE5  .4e6 NKRW5 4 NKRN3 3.5 HNPE5 1.2 THRE5  1e-4 IGN1 0
SWI6  0.1 SNI5  0.1 KRW5  .8 KRN5  .2 PRE5   4e6 NKRW5 4 NKRN3 3.5 HNPE5 1.2 THRE5  1e-4 IGN1 0

"""Properties rock"""
"""Kxy [mD], Kz [mD], phi [-], thickness [m]"""
PERMXY3 10.0 PERMZ3 10.0 PORO3 0.1 THIC1 10
PERMXY4 0.0001 PERMZ4 0.0001 PORO4 0.1 THIC2 50
PERMXY5 700.15 PERMZ5 700.15 PORO5 0.25 THIC2 20
PERMXY5 0.01 PERMZ5 0.01 PORO5 0.1 THIC2 25

"""Define the injection values""" 
"""injection time [d], time step size to write results [d], maximum time step [d], fluid (0 wetting, 1 non-wetting), injection rates [kg/day]"""
365 365 10 1 20000
90 10 10 1 0
% for _,control in enumerate(schedule):
7 7 1 1 ${-40000 if control == 0 else 40000}
% endfor
730 73 10 1 -20000