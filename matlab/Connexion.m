function update_Connexion( handles)

P_dyn_central_offset = 0;
P_dyn_pitot_offset = 0;%
P_alpha_offset = 0 ;% 0.9431;         % Offset pression verticale
P_beta_offset = 0; %0.9616;          % Offset preesion horizontale
P_baro_offset_1 = [1 0];  % Conversion baro  1 %%%%% Attention a voir avec l offset %%%%
% P_baro_offset_2 = [0.85762 -98.6542];  % Conversion baro  2 %%%%% Attention a voir avec l offset %%%%
alpha_k_offset = 0.083;  % Conversion Angle Pression verticale
% beta_k_offset = [0.067174 -0.0076319];  % Conversion Angle Pression Horzontale
beta_k_offset = 0.086;  % Conversion Angle Pression Horzontale
R = 8.3144598;      %gas constant [m^3PaK^-1mol^-1]
m = 0.02897;        %mass if 1 mol of air
R = R/m;
%=============== Selection affichage des  donnees
%================ Communication ===================%

%
%
% %================ Communication ===================%
Ouvrir_Connexion=get(handles.pushbutton2,'Value');
Fermer_Connexion=get(handles.radiobutton57,'Value');

%

AFF2D_Temp_Altitude=get(handles.radiobutton14,'Value');
AFF2D_Hum_Altitude=get(handles.radiobutton15,'Value');
Range=get(handles.slider1,'Value');
Sauvegarde_Donnees=get(handles.radiobutton13,'Value');
Nom_Fichier=get(handles.edit1,'String');
message5='';

Voie1_HCEM_DIFF=get(handles.radiobutton1,'Value');
Voie2_HCEM10_DIFF=get(handles.radiobutton2,'Value');
Voie3_HCEM_STAT=get(handles.radiobutton3,'Value');
Voie4_PRESSION_ABS_ADU=get(handles.radiobutton40,'Value');
Voie5_PRESSION_DIFF_ADU=get(handles.radiobutton41,'Value');
LDE_DIFF=get(handles.radiobutton58,'Value');

Voie6_Air_speed=get(handles.radiobutton6,'Value');
Voie7_altitude=get(handles.radiobutton7,'Value');

Voie8_wind_velN=get(handles.radiobutton34,'Value');
Voie9_wind_velE=get(handles.radiobutton4,'Value');
calc_windN=get(handles.radiobutton54,'Value');
calc_windE=get(handles.radiobutton55,'Value');


Voie11_ROLL_spa=get(handles.radiobutton19,'Value');
Voie12_PITCH_spa=get(handles.radiobutton17,'Value');
Voie13_HEAD_spa=get(handles.radiobutton18,'Value');
Voie14_G=get(handles.radiobutton45,'Value');
Voie11_ROLL_mot=get(handles.radiobutton42,'Value');
Voie12_PITCH_mot=get(handles.radiobutton43,'Value');
Voie13_HEAD_mot=get(handles.radiobutton44,'Value');

Voie14_Temp_SHT1=get(handles.radiobutton36,'Value');
Voie15_Hum_SHT1=get(handles.radiobutton37,'Value');
Voie17_Temp_SHT2=get(handles.radiobutton38,'Value');
Voie18_Hum_SHT2=get(handles.radiobutton39,'Value');
Voie19_PT100=get(handles.radiobutton46,'Value');

Voie_numblock=get(handles.radiobutton53,'Value');
Voie_cpt100=get(handles.radiobutton52,'Value');
Voie_tpsmort=get(handles.radiobutton51,'Value');
Voie_tpsmort_moy=get(handles.radiobutton56,'Value');
Pas_dAffichage=get(handles.radiobutton15,'Value');
Affichage_zoom=get(handles.radiobutton14,'Value');
type_ATP=get(handles.radiobutton47,'Value');

if type_ATP
    plot_acclxM=get(handles.radiobutton48,'Value');
    plot_acclyM=get(handles.radiobutton49,'Value');
    plot_acclzM=get(handles.radiobutton50,'Value');
    liste_AccM=[double(plot_acclxM) double(plot_acclyM) double(plot_acclzM)];
    Nombre_graph_AcclM= sum(liste_AccM(:));
    local_port=str2num(get(handles.edit8,'string'));
    Val_Com=local_port;


else
    Nombre_graph_AcclM=0;
    Val2_Com=cellstr(get(handles.listbox1,'String'));
    Val_Com=get(handles.listbox1,'value');
    PortCom=Val2_Com{Val_Com};

end

s=handles.connection;
%=============== Selection affichage des  donnees
liste_P=[double(Voie1_HCEM_DIFF) double(Voie2_HCEM10_DIFF) double(Voie5_PRESSION_DIFF_ADU) double(Voie3_HCEM_STAT) double(Voie4_PRESSION_ABS_ADU) double(LDE_DIFF) ];
liste_AS=[double(Voie6_Air_speed) double(Voie7_altitude)];
liste_WP=[double(Voie8_wind_velN) double(Voie9_wind_velE) double(calc_windN) double(calc_windE)];
liste_SS=[double(Voie11_ROLL_spa) double(Voie12_PITCH_spa) double(Voie13_HEAD_spa) double(Voie14_G) double(Voie11_ROLL_mot) double(Voie12_PITCH_mot) double(Voie13_HEAD_mot)];
liste_TH=[double(Voie14_Temp_SHT1) double(Voie17_Temp_SHT2) double(Voie19_PT100) double(Voie15_Hum_SHT1)  double(Voie18_Hum_SHT2) ];
liste_tpsmort=[double(Voie_numblock) double(Voie_cpt100)  double(Voie_tpsmort) double(Voie_tpsmort_moy)];
Nombre_graph_P= sum(liste_P(:));
Nombre_graph_AS = sum(liste_AS(:));
Nombre_graph_WP =sum(liste_WP(:));
Nombre_graph_SS = sum(liste_SS(:));
Nombre_graph_TH= sum(liste_TH(:));
Nombre_graph_Tpsmort= sum(liste_tpsmort(:));
Nombre_graph_GNSS=0;
Pouet=Nom_Fichier{1};
NomFichier=sprintf('%s.mat',Pouet);

% message_affichage='----------------------';
message0 = ' ';
message1 = sprintf('%sLe numero du port est: #%d\n',message0,Val_Com);

if AFF2D_Temp_Altitude
    message2 = sprintf('Affichage Temp/Altitude \n ');
else
    message2 = sprintf('Pas affichage Temp/Altitude \n ');
end

if AFF2D_Hum_Altitude
    message3 = sprintf('Affichage Hum/Altitude \n ');
else
    message3 = sprintf('Pas affichage Temp/Altitude \n ');
end

if Sauvegarde_Donnees
    message4 = sprintf('Sauvegarde donnees en cours \n ');
else
    message4 = sprintf('Pas de sauvegarde donnees en cours \n ');
end

message = sprintf('%s %s %s %s %s',message1,message2,message3,message4,message5);
set(handles.text2,'string',message);

sRange=int2str(Range);
message = sprintf('%sLe nombre de point est: %s\n',message0,sRange);
set(handles.text5,'string',message);

j=1;
u=0;
%===============================%
boucle=0;
boucle10=0;

%============= Ouvrir Connexion ===============%
if Ouvrir_Connexion %& (Fermer_Connexion ~= 'false')
    if type_ATP
        DataLenght= 134;  %15 %32;%
        message1 = sprintf(['Le numero du port est: ' num2str(local_port) '\n']);
        message5 = sprintf('Liaison ouverte  \n');
    else
        set(s,'Timeout',10);
        message0 = ' ';
        message1 = sprintf('%sLe numero du port est: #%d\n',message0,Val_Com);
        message5 = sprintf('Liaison ouverte  \n');
        DataLenght=1024;%1024;

    end
    
    if AFF2D_Temp_Altitude
        message2 = sprintf('Affichage Temp/Altitude \n ');
    else
        message2 = sprintf('Pas affichage Temp/Altitude \n ');
    end
    if AFF2D_Hum_Altitude
        message3 = sprintf('Affichage Hum/Altitude \n ');
    else
        message3 = sprintf('Pas affichage Temp/Altitude \n ');
    end
    if Sauvegarde_Donnees
        message4 = sprintf('Sauvegarde donnees en cours \n ');
    else
        message4 = sprintf('Pas de sauvegarde donnees en cours \n ');
    end
     
    messagenew = sprintf('%s %s %s %s %s',message1,message2,message3,message4,message5);
    if ~strcmp(messagenew,message)
        message=messagenew;
        set(handles.text2,'string',message);
    end
        
    timeoutVal = 6; % Number of seconds to wait for data before killing the program
    timeout = 0;
    boucle2=0;
    
    AirDataSensors_temp=[];
    PaquetWind_temp=[];
    PaquetAirData_temp=[];
    MOTUSORI_temp=[];
    AD_NAVIGATION_temp=[];
    TH_temp=[];
    T2_temp=[];
    Hdopp_temp=[];
    Vdopp_temp=[];
    time_Vdopp_Hdopp=[];
    Q=[];
    Cpt100hz=[];
    BlockSD=[];
    Tps_mort_moy=[];
    Cpt100hz_temp=[];
    BlockSD_temp=[];
    Tps_mort=[];
    Result=[];
    Calcul_Vent_VitesseNord_temp=[];
    Calcul_Vent_VitesseEast_temp=[];
    maxseuilhaut=1000;
    enable_plot=0;
    if Fermer_Connexion
        first_char = 0;
    else
        while (timeout < timeoutVal) && Ouvrir_Connexion 
            if (s.BytesAvailable > DataLenght-1) || type_ATP
                timeout = 0;
                if type_ATP
                    TransferStatus = 'idle';
                else
                    TransferStatus=s.TransferStatus;
                end
                if (TransferStatus == 'idle')
                   pause(0.5);
                    %=============== Selection affichage des  donnees
                    f = findobj(0,'type','figure');
                    plot_on=zeros(8,1);
                    for k=1:length(f)
                        if strcmp(f(k).Name,'PRESSION')
                            plot_on(1)=1;
                            fig1=f(k);
                        elseif strcmp(f(k).Name,'AIR SPEED')
                            plot_on(2)=1;
                            fig2=f(k);
                        elseif strcmp(f(k).Name,'WIND PACQUET')
                            plot_on(3)=1;
                            fig3=f(k);
                        elseif strcmp(f(k).Name,'SYSTEM STATE')
                            plot_on(4)=1;
                            fig4=f(k);
                        elseif strcmp(f(k).Name,'TEMPERATURE & HUMIDITE')
                            plot_on(5)=1;
                            fig5=f(k);
                        elseif strcmp(f(k).Name,'Acceleration Motus')
                            plot_on(6)=1;
                            fig6=f(k);
                        elseif strcmp(f(k).Name,'Temps mort SD')
                            plot_on(7)=1;
                            fig7=f(k);
                        elseif strcmp(f(k).Name,'Hdopp/Vdopp')
                            plot_on(8)=1;
                            fig8=f(k);
                        end
                    end
                    %                     Test_Connexion=get(handles.pushbutton1,'Value');
                    Ouvrir_Connexion=get(handles.pushbutton2,'Value');
                    Fermer_Connexion=get(handles.radiobutton57,'Value');

                    if Fermer_Connexion
                        set(handles.radiobutton14,'Value',0);
                        set(handles.radiobutton14,'enable','off');
                        set(handles.radiobutton59,'Value',0);
                        set(handles.radiobutton59,'enable','off');
                        set(handles.text28,'string','Statut GNSS off');
                        fclose(s);
                        delete(s);
                        clear s
                        set(handles.text2,'string','liaison fermée');
                        break;
                    end

                    AFF2D_Temp_Altitude=get(handles.radiobutton14,'Value');
                    AFF2D_Hum_Altitude=get(handles.radiobutton15,'Value');
                    Range=get(handles.slider1,'Value');
                    Sauvegarde_Donnees=get(handles.radiobutton13,'Value');
                    Nom_Fichier=get(handles.edit1,'String');

                    sRange=int2str(Range);
                    message = sprintf(' Le nombre de point est: %s\n',sRange);
                    set(handles.text5,'string',message);
                    message5='';
                    
                    Voie1_HCEM_DIFF=get(handles.radiobutton1,'Value');
                    Voie2_HCEM10_DIFF=get(handles.radiobutton2,'Value');
                    Voie3_HCEM_STAT=get(handles.radiobutton3,'Value');
                    Voie4_PRESSION_ABS_ADU=get(handles.radiobutton40,'Value');
                    Voie5_PRESSION_DIFF_ADU=get(handles.radiobutton41,'Value');
                    LDE_DIFF=get(handles.radiobutton58,'Value');
                    
                    Voie6_Air_speed=get(handles.radiobutton6,'Value');
                    Voie7_altitude=get(handles.radiobutton7,'Value');
                    
                    Voie8_wind_velN=get(handles.radiobutton34,'Value');
                    Voie9_wind_velE=get(handles.radiobutton4,'Value');
                    calc_windN=get(handles.radiobutton54,'Value');
                    calc_windE=get(handles.radiobutton55,'Value');
                    
                    
                    Voie11_ROLL_spa=get(handles.radiobutton19,'Value');
                    Voie12_PITCH_spa=get(handles.radiobutton17,'Value');
                    Voie13_HEAD_spa=get(handles.radiobutton18,'Value');
                    Voie14_G=get(handles.radiobutton45,'Value');
                    Voie11_ROLL_mot=get(handles.radiobutton42,'Value');
                    Voie12_PITCH_mot=get(handles.radiobutton43,'Value');
                    Voie13_HEAD_mot=get(handles.radiobutton44,'Value');
                    
                    Voie14_Temp_SHT1=get(handles.radiobutton36,'Value');
                    Voie15_Hum_SHT1=get(handles.radiobutton37,'Value');
                    Voie17_Temp_SHT2=get(handles.radiobutton38,'Value');
                    Voie18_Hum_SHT2=get(handles.radiobutton39,'Value');
                    Voie19_PT100=get(handles.radiobutton46,'Value');
                    
                    Voie_numblock=get(handles.radiobutton53,'Value');
                    Voie_cpt100=get(handles.radiobutton52,'Value');
                    Voie_tpsmort=get(handles.radiobutton51,'Value');
                    Voie_tpsmort_moy=get(handles.radiobutton56,'Value');
                    Pas_dAffichage=get(handles.radiobutton15,'Value');
                    Affichage_zoom=get(handles.radiobutton14,'Value');
                    type_ATP=get(handles.radiobutton47,'Value');
                    
                    Hdopp_Vdopp=get(handles.radiobutton59,'Value');
                    
                    if type_ATP
                        plot_acclxM=get(handles.radiobutton48,'Value');
                        plot_acclyM=get(handles.radiobutton49,'Value');
                        plot_acclzM=get(handles.radiobutton50,'Value');
                        liste_AccM=[double(plot_acclxM) double(plot_acclyM) double(plot_acclzM)];
                        Nombre_graph_AcclM= sum(liste_AccM(:));
                        
                    else
                        Nombre_graph_AcclM=0;
%                         fclose(s);
                    end
                    
                    
                    %=============== Selection affichage des  donnees
                    liste_P=[double(Voie1_HCEM_DIFF) double(Voie2_HCEM10_DIFF) double(Voie5_PRESSION_DIFF_ADU) double(Voie3_HCEM_STAT) double(Voie4_PRESSION_ABS_ADU) double(LDE_DIFF)];
                    liste_AS=[double(Voie6_Air_speed) double(Voie7_altitude)];
                    liste_WP=[double(Voie8_wind_velN) double(Voie9_wind_velE) double(calc_windN) double(calc_windE)];
                    liste_SS=[double(Voie11_ROLL_spa) double(Voie12_PITCH_spa) double(Voie13_HEAD_spa) double(Voie14_G) double(Voie11_ROLL_mot) double(Voie12_PITCH_mot) double(Voie13_HEAD_mot)];
                    liste_TH=[double(Voie14_Temp_SHT1) double(Voie17_Temp_SHT2) double(Voie19_PT100) double(Voie15_Hum_SHT1)  double(Voie18_Hum_SHT2) ];
                    liste_tpsmort=[double(Voie_numblock) double(Voie_cpt100)  double(Voie_tpsmort) double(Voie_tpsmort_moy)];
                    Nombre_graph_P= sum(liste_P(:));
                    Nombre_graph_AS = sum(liste_AS(:));
                    Nombre_graph_WP =sum(liste_WP(:));
                    Nombre_graph_SS = sum(liste_SS(:));
                    Nombre_graph_TH= sum(liste_TH(:));
                    Nombre_graph_Tpsmort= sum(liste_tpsmort(:));
                    Pouet=Nom_Fichier{1};
                    NomFichier=sprintf('%s.mat',Pouet);
                    if enable_plot==1
                        set(handles.radiobutton14,'enable','on');
                    else
                        set(handles.radiobutton14,'enable','off');
                    end

                    if Affichage_zoom==1
                        N_frames=size(PaquetAirData_temp,1);
                        if maxseuilhaut<N_frames
                            maxseuilhaut=N_frames*1000;
                        end
                        stepval=N_frames-1;
                        set(handles.slider7, 'Min', 1,'Max', maxseuilhaut, 'SliderStep', [1/stepval, 10/stepval]);
                        seuil_haut2=fix(get(handles.slider7,'Value'));
                        if seuil_haut2>N_frames
                            seuil_haut2=N_frames;
                        end
                        max2=seuil_haut2-1;
                        if max2>2
                            stepval2=max2-1;
                            set(handles.slider6, 'Min', 1,'Max', max2, 'SliderStep', [1/stepval2, 10/stepval2]);
                            seuil_bas2=fix(get(handles.slider6,'Value'));
                        else
                            seuil_bas2=1;
                        end
                        
                        sRangehaut= num2str(seuil_haut2);
                        message_seuilHAUT = sprintf('%sSeuil Haut :Le nombre de point est: %s\n',message0,sRangehaut);
                        sRangebas= num2str(seuil_bas2);
                        message_seuilBAS= sprintf('%sSeuil Bas :Le nombre de point est: %s\n',message0,sRangebas);
                        set(handles.slider7, 'Min', 1,'Max', maxseuilhaut, 'SliderStep', [1/stepval, 10/stepval]);
                        set(handles.slider6, 'Min', 1,'Max', max2, 'SliderStep', [1/stepval2, 10/stepval2]);
                        set(handles.text25,'string',message_seuilHAUT);
                        set(handles.text26,'string',message_seuilBAS);
                    end
                    
                    if type_ATP
                        q_ATP = fread(s, 128);
                        if length(q_ATP)==128
%                             q_128=[q_134(1:126);q_134(133:134)];
                            q = APT_to_PC( q_ATP );
                        end
                        
                    else
%                         q_128 = fread(s, 128);
%                         if length(q_128)==128
% %                             q_128=[q_134(1:126);q_134(133:134)];
%                             q = APT_to_PC( q_128 );
%                         end
                        q = fread(s, DataLenght, 'char');
                    end
                    length(q);
                    if length(q)==1024
                        if q(235)==170 && q(236)==187 && q(448)==170 && q(449)==170% %On check que toute la trame est correcte%
                            Q=[Q q];
                            if size(Q,2)>10
                                enable_plot=1;
                            else
                                enable_plot=0;
                            end
                            Resulti = extract_data(q,1,0);
                            if Resulti.AD_Satellite(:,4)==1                             
                                message = [' GNSS 3D FIX: OK' ' lat:' num2str(Resulti.AD_NAVIGATION(1,6),'%2.3f') '° ' 'long:' num2str(Resulti.AD_NAVIGATION(1,7),'%2.3f') '°'] ;
                                set(handles.text28,'string',message);
                                set(handles.radiobutton59,'enable','on');
                                if Hdopp_Vdopp==1
                                    Nombre_graph_GNSS=1;
                                else
                                    Nombre_graph_GNSS=0;                              
                                end
                            else
                                message = sprintf(' PAS DE 3D FIX \n');
                                set(handles.text28,'string',message);
%                                 set(handles.radiobutton59,'enable','off');
%                                 set(handles.radiobutton59,'Value',0);
%                                 Nombre_graph_GNSS=0;
                            end
                                
                                numblock=Resulti.AD_NAVIGATION(:,1);
                                cpt100hz=Resulti.AD_NAVIGATION(:,27);
                            Cpt100hz=[Cpt100hz;cpt100hz];
                            BlockSD=[BlockSD;numblock];
                            
                            if length(BlockSD)>1
                                numero_block_theo=BlockSD(end-1)+(Cpt100hz(end)-Cpt100hz(end-1))*2;
                                diff_cpt=numero_block_theo-BlockSD(end);
                                Result.MOTUSRAW=[Result.MOTUSRAW;Resulti.MOTUSRAW];
                                Result.Pressures=[Result.Pressures;Resulti.Pressures];
                                if (BlockSD(end)-BlockSD(end-1))~=0
                                    tps=((Cpt100hz(end)-Cpt100hz(end-1))*2/(BlockSD(end)-BlockSD(end-1))-1);
                                else
                                    tps=100;
                                end
                                Tps_mort=[Tps_mort; repmat(tps,10,1)];
                                Cpt100hz_temp=[Cpt100hz_temp;ones(10,1)*(Cpt100hz(end)-Cpt100hz(end-1))];
                                BlockSD_temp=[BlockSD_temp;ones(10,1)*(BlockSD(end)-BlockSD(end-1))];
                                if mod(length(BlockSD),100)==0
                                    if BlockSD(end)-BlockSD(end-99)~=0
                                        tps_moy=((Cpt100hz(end)-Cpt100hz(end-99))*2/(BlockSD(end)-BlockSD(end-99))-1)*100;
                                        Tps_mort_moy=[Tps_mort_moy;ones(1000,1)*tps_moy ];
                                    else
                                        Tps_mort_moy=[Tps_mort_moy;ones(1000,1)*100 ];
                                    end
                                    
                                end
                            else
                                Tps_mort=[Tps_mort;zeros(10,1)];
                                Cpt100hz_temp=[Cpt100hz_temp;zeros(10,1)];
                                BlockSD_temp=[BlockSD_temp;zeros(10,1)];
                                Tps_mort_moy=[Tps_mort_moy;zeros(1000,1)];
                                Result=Resulti;
                            end
                            
                            AirDataSensors_temp=[AirDataSensors_temp;repmat(Resulti.AirDataSensors(end,:),10,1)];
                            PaquetWind_temp=[PaquetWind_temp;repmat(Resulti.PaquetWind(end,:),10,1)];
                            PaquetAirData_temp=[PaquetAirData_temp;repmat(Resulti.PaquetAirData(end,:),10,1)];
                            MOTUSORI_temp=[MOTUSORI_temp;repmat(Resulti.MOTUSORI(end,:),10,1)];
                            AD_NAVIGATION_temp=[AD_NAVIGATION_temp;repmat(Resulti.AD_NAVIGATION(end,:),10,1)];
                            TH_temp=[TH_temp;repmat(Resulti.TH(end,:),10,1)];
                            T2_temp=[T2_temp;repmat(Resulti.T2(end,:),10,1)];
                            ADV_V_Nord=Resulti.AD_NAVIGATION(:,9);
                            ADV_V_East=Resulti.AD_NAVIGATION(:,10);
                            Hdopp_temp=[Hdopp_temp;repmat(Resulti.AD_Satellite(end,2),10,1)];
                            Vdopp_temp=[Vdopp_temp;repmat(Resulti.AD_Satellite(end,3),10,1)];
                           

                            tps=0:1:size(T2_temp,1)-1;
                            
                            %Calculate ROLL
                            poub=Resulti.AD_NAVIGATION(:,16);
                            x=cosd(poub);
                            y=sind(poub);
                            ADV_Roll_degre= (atan2d(y,x));
                            ADV_Roll= (atan2(y,x));
                            % pitch
                            poub=Resulti.AD_NAVIGATION(:,17);
                            x=cosd(poub(:));
                            y=sind(poub(:));
                            ADV_Pitch_degre= (atan2d(y,x));
                            ADV_Pitch=(atan2(y,x));
                            
                            % Heading
                            poub=Resulti.AD_NAVIGATION(:,18);
                            x=cosd(poub(:,1));
                            y=sind(poub(:,1));
                            ADV_Heading_degre= mod(atan2d(y,x),360);
                            ADV_Heading=mod(atan2d(y,x),2*pi);
                            
                            p_vert= Resulti.Pressures(:,20);
                            p_vert=p_vert-P_alpha_offset;
                            
                            p_centrale= Resulti.Pressures(:,14);
                            p_centrale=p_centrale-P_dyn_central_offset;
                            
                            p_horiz= Resulti.Pressures(:,19);
                            p_horiz=p_horiz-P_beta_offset;
                            
                            p_Stat1= Resulti.Pressures(:,12);
                            p_Stat1=(p_Stat1+P_baro_offset_1(2))/P_baro_offset_1(1);
                            
                            p_Pitot= Resulti.Pressures(:,16);
                            p_Pitot=p_Pitot+P_dyn_pitot_offset;
                            
                            Temp10z=Resulti.T2(:,3);
                            
                            r = 100*p_Stat1./(R*(Temp10z+273));  % 100 pour convsersion mb=>pascal et degre kelvin
                            Calcul_AirSpeed_5trous = sqrt(abs((200.*p_centrale)./r)); %Bernoulli eq'n using mbar
                            Calcul_AirSpeed_Pitot = sqrt(abs((200.*p_Pitot)./r)).*1;
                            
                            Calcul_Alpha = p_vert ./( p_centrale*alpha_k_offset(1) );
                            Calcul_Beta =(-1)*p_horiz./( p_centrale*beta_k_offset(1));  % inversion cablage cpateur pression
                            
                            Phi=ADV_Roll_degre;
                            Theta=ADV_Pitch_degre;
                            Psi=ADV_Heading_degre;
                            % Modele complexe de lenchow
%                             D = ( 1 + (tand(Calcul_Alpha)).^2 + (tand(Calcul_Beta)).^2).^0.5;
%                             
%                             Etape1=sind(Psi).*cosd(Theta);
%                             Etape2=tand(Calcul_Beta).*(cosd(Psi).*cosd(Phi) + sind(Psi).*sind(Theta).*sind(Phi));
%                             Etape3=tand(Calcul_Alpha).*(sind(Psi).*sind(Theta).*cosd(Phi) - cosd(Psi).*sind(Phi));
%                             Calcul_Vent_VitesseEast=(-1./D).*Calcul_AirSpeed_5trous .*(Etape1+Etape2 + Etape3)+ ADV_V_East;
%                             
%                             Etape4=cosd(Psi).*cosd(Theta);
%                             Etape5=tand(Calcul_Beta).*(sind(Psi).*cosd(Phi)-cosd(Psi).*sind(Theta).*sind(Phi));
%                             Etape6=tand(Calcul_Alpha).*(cosd(Psi).*sind(Theta).*cosd(Phi) + sind(Psi).*sind(Phi));
%                             Calcul_Vent_VitesseNord=(-1./D).*Calcul_AirSpeed_5trous .*(Etape4-Etape5 + Etape6)+ADV_V_Nord;
%                             
                            Vitesse_VE_OVLI_simpl=-Calcul_AirSpeed_5trous.*sind(Psi+Calcul_Beta)+ ADV_V_East;% Vitesse vent EST
                            Vitesse_VN_OVLI_simpl=-Calcul_AirSpeed_5trous.*cosd(Psi+Calcul_Beta)+ ADV_V_Nord;%Vitesse vent nord
                            Calcul_Vent_VitesseNord_temp=[Calcul_Vent_VitesseNord_temp;repmat(Vitesse_VN_OVLI_simpl,10,1)];
                            Calcul_Vent_VitesseEast_temp=[Calcul_Vent_VitesseEast_temp;repmat(Vitesse_VE_OVLI_simpl,10,1)];
                            
                            
                            boucle= boucle+1;
                            boucle10= boucle10+10;
                            %%=============================================================%
                            %         Affichage
                            %=============================================================%
                            %======================Affichage Donnees======================%
                            if Pas_dAffichage == 0
                                if boucle10<Range  % affichage des 10 derniers points
                                    seuil_bas10= 1;
                                    seuil_haut10=fix(boucle10);
                                else
                                    seuil_bas10= fix(boucle10 -( Range -1));
                                    seuil_haut10=fix(boucle10);
                                end
                                if Nombre_graph_GNSS>0
                                    
                                    if plot_on(8)==0
                                        fig8=figure(9);
                                        fig8.Name='Hdopp/Vdopp';
                                        set(0,'CurrentFigure',fig8)
                                    end
                                    set(0,'CurrentFigure',fig8)
                                    subplot(2,1,1)
                                    x=tps(seuil_bas10:seuil_haut10);
                                    plot(x,Hdopp_temp(seuil_bas10:seuil_haut10));
                                    xlabel('t en ms')
                                    legend('Hdopp')
                                    subplot(2,1,2)
                                    plot(x,Vdopp_temp(seuil_bas10:seuil_haut10));
                                    xlabel('t en ms')
                                    legend('Vdopp')
                                end
                                
                                if Nombre_graph_P > 0                  %fenÃªtre capteur Ozone
                                    list_ind={};
                                    LEG={};
                                    ylab={};
                                    if plot_on(1)==0
                                        fig1=figure(2);
                                        fig1.Name='PRESSION';
                                        set(0,'CurrentFigure',fig1)
                                    end
                                    LEG{1,1}='HCEM 2 Sonde 5T';
                                    LEG{1,2}='HCEM 3 Sonde 5T';
                                    LEG{1,3}='HCEM 4 Pitot';
                                    LEG{1,4}='HCEM 5 Pitot';
                                    LEG{2,1}='HCEM10 1: HAUT-BAS';
                                    LEG{2,2}='HCEM10 2: HAUT-BAS';
                                    LEG{2,3}='HCEM10 3: GAUCHE-DROITE';
                                    LEG{2,4}='HCEM10 4: GAUCHE-DROITE';
                                    LEG{3,1}='ADU diff';
                                    LEG{4,1}='HCEM statique 1';
                                    LEG{4,2}='HCEM statique 2';
                                    LEG{5,1}='ADU abs';
                                    LEG{6,1}='LDE1: HAUT-BAS ';
                                    LEG{6,2}='LDE2: GAUCHE-DROITE ';
                                    list_ind{1}=14:17;
                                    list_ind{2}=18:21;
                                    list_ind{3}=3;
                                    list_ind{4}=12:13;
                                    list_ind{5}=2;
                                    list_ind{6}=24:25;
                                    titre{1}='HCEM DIFF';
                                    titre{2}='HCEM10 diff';
                                    titre{3}='PRESSION DIFF ADU';
                                    titre{4}='HCEM STAT';
                                    titre{5}='PRESSION ABS ADU';
                                    titre{6}='LDE';
                                    
                                    ylab{1}='mbar';
                                    ylab{2}='mbar';
                                    ylab{3}='Pa';
                                    ylab{4}='mbar';
                                    ylab{5}='Pa';
                                    ylab{6}='mbar';
                                    if Affichage_zoom
                                        seuil_bas10=seuil_bas2;
                                        seuil_haut10=seuil_haut2;
                                    end
                                    if Nombre_graph_P>3
                                        nb_ligne=2;
                                        nb_col=floor(Nombre_graph_P/2)+mod(Nombre_graph_P,2);
                                    elseif Nombre_graph_P==1 && liste_P(end)==1
                                        nb_ligne=1;
                                        nb_col=2;
                                        
                                    else
                                        nb_ligne=1;
                                        nb_col=sum(liste_P(:));
                                    end
                                    
                                    if Nombre_graph_P==1 && liste_P(end)==1
                                        list_temp=list_ind{6};
                                        for k_p=1:2
                                            set(0,'CurrentFigure',fig1)
                                            subplot(nb_ligne,nb_col,k_p);
                                            x=tps(seuil_bas10:seuil_haut10);
                                            y=Result.Pressures(seuil_bas10:seuil_haut10,list_temp(:,k_p));
%                                             y_lim=[min(y) max(y)];
                                            plot(x,y);
%                                             ylim(y_lim)
                                            title(titre{6})
                                            xlabel('t en ms')
                                            ylabel(ylab{6})
                                        end
                                    else
                                        
                                        for k_p=1:length(liste_P)
                                            if liste_P(k_p)==1   %===========================% fenetre 1
                                                x=tps(seuil_bas10:seuil_haut10);
                                                if k_p==1 || k_p==2 || k_p==4 || k_p==6
                                                    y=Result.Pressures(seuil_bas10:seuil_haut10,list_ind{k_p});
                                                else
                                                    y=AirDataSensors_temp(seuil_bas10:seuil_haut10,list_ind{k_p});
                                                end
                                                nbrePlot=sum(liste_P(1:k_p));
                                                set(0,'CurrentFigure',fig1)
                                                subplot(nb_ligne,nb_col,nbrePlot);
                                                plot(x,y,'-*')
                                                title(titre{k_p})
                                                xlabel('t en ms')
                                                ylabel(ylab{k_p})
                                                hold off
                                                legend(LEG{k_p,1:length(list_ind{k_p})})
                                            end
                                        end
                                    end
                                end
                                
                                if Nombre_graph_AS > 0                  %fenetre Airspeed
                                    list_ind={};
                                    LEG={};
                                    ylab={};
                                    if plot_on(2)==0
                                        fig2=figure(3);
                                        fig2.Name='AIR SPEED';
                                        set(0,'CurrentFigure',fig2)
                                    end
                                    offset=liste_AS(1)+liste_AS(2);
                                    LEG{1,1}='air speed';
                                    LEG{2,1}='altitude';
                                    list_ind{1}=5;
                                    list_ind{2}=4;
                                    titre{1}='air speed';
                                    titre{2}='altitude';
                                    nb_ligne=1;
                                    ylab{1}='m/s';
                                    ylab{2}='m';
                                    
                                    if Affichage_zoom
                                        seuil_bas10=seuil_bas2;
                                        seuil_haut10=seuil_haut2;
                                    end
                                    for k_as=1:length(liste_AS)
                                        if liste_AS(k_as)==1   %===========================% fenetre 1
                                            nbrePlot=sum(liste_AS(1:k_as));
                                            set(0,'CurrentFigure',fig2)
                                            subplot(nb_ligne,offset,nbrePlot);
                                            plot(tps(seuil_bas10:seuil_haut10),PaquetAirData_temp(seuil_bas10:seuil_haut10,list_ind{k_as}),'-*')
                                            legend(LEG{k_as,1:length(list_ind{k_as})})
                                            hold off
                                            title(titre{k_as})
                                            xlabel('t en ms')
                                            ylabel(ylab{k_as});
                                        end
                                    end
                                end
                                
                                if Nombre_graph_WP > 0  % fenetre WindPacket
                                    list_ind={};
                                    LEG={};
                                    ylab={};
                                    if plot_on(3)==0
                                        fig3=figure(4);
                                        fig3.Name='WIND PACQUET';
                                    end
                                    LEG{1,1}='wind velocity N ADU';
                                    LEG{2,1}='wind velocity E ADU';
                                    LEG{3,1}='wind velocity N calcul';
                                    LEG{4,1}='wind velocity calcul';
                                    list_ind{1}=2;
                                    list_ind{2}=3;
                                    list_ind{3}=1;
                                    list_ind{4}=1;
                                    titre{1}='wind velocity N';
                                    titre{2}='wind velocity E';
                                    titre{3}='wind velocity N calc';
                                    titre{4}='wind velocity E calc';
                                    ylab{1}='m/s';
                                    ylab{2}='m/s';
                                    ylab{3}='m/s';
                                    ylab{4}='m/s';
                                    
                                    
                                    if Affichage_zoom
                                        seuil_bas10=seuil_bas2;
                                        seuil_haut10=seuil_haut2;
                                    end
                                    if sum(liste_WP(3:end))>=1 && sum(liste_WP(1:2))>=1
                                        nb_ligne=2;
                                        nb_col=max(sum(liste_WP(3:end)),sum(liste_WP(1:2)));
                                        offset=0;
                                    else
                                        nb_ligne=1;
                                        nb_col=sum(liste_WP(:));
                                        offset=0;
                                    end
                                    for k_wp=1:length(liste_WP)
                                        if k_wp<=2 && liste_WP(k_wp)==1  %===========================% fenetre 1
                                            nbrePlot=sum(liste_WP(1:k_wp));
                                            set(0,'CurrentFigure',fig3)
                                            subplot(nb_ligne,nb_col,nbrePlot);
                                            plot(tps(seuil_bas10:seuil_haut10),PaquetWind_temp(seuil_bas10:seuil_haut10,list_ind{k_wp}),'-*')
                                            legend(LEG{k_wp,1:length(list_ind{k_wp})})
                                            hold off
                                            title(titre{k_wp})
                                            xlabel('t en ms')
                                            ylabel(ylab{k_wp});
                                        elseif k_wp==3 && liste_WP(k_wp)==1
                                            nbrePlot=sum(liste_WP(1:k_wp))+offset;
                                            set(0,'CurrentFigure',fig3)
                                            subplot(nb_ligne,nb_col,nbrePlot);
                                            plot(tps(seuil_bas10:seuil_haut10),Calcul_Vent_VitesseEast_temp(seuil_bas10:seuil_haut10,list_ind{k_wp}),'-*')
                                            legend(LEG{k_wp,1:length(list_ind{k_wp})})
                                            hold off
                                            title(titre{k_wp})
                                            xlabel('t en ms')
                                            ylabel(ylab{k_wp});
                                        elseif k_wp==4 && liste_WP(k_wp)==1
                                            nbrePlot=sum(liste_WP(1:k_wp))+offset;
                                            set(0,'CurrentFigure',fig3)
                                            subplot(nb_ligne,nb_col,nbrePlot);
                                            plot(tps(seuil_bas10:seuil_haut10),Calcul_Vent_VitesseNord_temp(seuil_bas10:seuil_haut10,list_ind{k_wp}),'-*')
                                            legend(LEG{k_wp,1:length(list_ind{k_wp})})
                                            hold off
                                            title(titre{k_wp})
                                            xlabel('t en ms')
                                            ylabel(ylab{k_wp});
                                        end
                                        
                                    end
                                end
                                
                                if Nombre_graph_SS > 0 %fenetre systeme state
                                    list_ind={};
                                    LEG={};
                                    ylab={};
                                    if plot_on(4)==0
                                        fig4=figure(5);
                                        fig4.Name='SYSTEM STATE';
                                    end
                                    if Affichage_zoom
                                        seuil_bas10=seuil_bas2;
                                        seuil_haut10=seuil_haut2;
                                    end
                                    LEG{1,1}='Roll Spatial';
                                    LEG{2,1}='Pitch Spatial';
                                    LEG{3,1}='Heading Spatial';
                                    LEG{4,1}='G';
                                    LEG{5,1}='Roll Motus';
                                    LEG{6,1}='Pitch Motus';
                                    LEG{7,1}='Heading Motus';
                                    list_ind{1}=16;
                                    list_ind{2}=17;
                                    list_ind{3}=18;
                                    list_ind{4}=15;
                                    list_ind{5}=2;
                                    list_ind{6}=3;
                                    list_ind{7}=4;
                                    titre{1}='Roll Spatial';
                                    titre{2}='Pitch Spatial';
                                    titre{3}='Heading Spatial';
                                    titre{4}='G';
                                    titre{5}='Roll Motus';
                                    titre{6}='Pitch Motus';
                                    titre{7}='Heading Motus';
                                    ylab{1}='deg';
                                    ylab{2}='deg';
                                    ylab{3}='deg';
                                    ylab{4}='g/g0';
                                    ylab{5}='deg';
                                    ylab{6}='deg';
                                    ylab{7}='deg';
                                    if sum(liste_SS(5:end))>=1 && sum(liste_SS(1:4))>=1
                                        nb_ligne=2;
                                        nb_col=max(sum(liste_SS(5:end)),sum(liste_SS(1:4)));
                                        offset=nb_col;
                                    else
                                        nb_ligne=1;
                                        nb_col=sum(liste_SS(:));
                                        offset=0;
                                    end
                                    for k_ss=1:length(liste_SS)
                                        if liste_SS(k_ss)==1   %===========================% fenetre 1
                                            
                                            if k_ss<5
                                                nbrePlot=sum(liste_SS(1:k_ss));
                                                set(0,'CurrentFigure',fig4)
                                                subplot(nb_ligne,nb_col,nbrePlot);
                                                plot(tps(seuil_bas10:seuil_haut10),AD_NAVIGATION_temp(seuil_bas10:seuil_haut10,list_ind{k_ss}),'-*')
                                            else
                                                nbrePlot=sum(liste_SS(5:k_ss))+offset;
                                                set(0,'CurrentFigure',fig4)
                                                subplot(nb_ligne,nb_col,nbrePlot);
                                                plot(tps(seuil_bas10:seuil_haut10),MOTUSORI_temp(seuil_bas10:seuil_haut10,list_ind{k_ss}),'-*')
                                            end
                                            legend(LEG{k_ss,1:length(list_ind{k_ss})})
                                            hold off
                                            title(titre{k_ss})
                                            xlabel('t en ms')
                                            ylabel(ylab{k_ss});
                                        end
                                    end
                                end
                                
                                if Nombre_graph_TH > 0 %fenetre sht +pt100
                                    list_ind={};
                                    LEG={};
                                    ylab={};
                                    if plot_on(5)==0
                                        fig5=figure(6);
                                        fig5.Name='TEMPERATURE & HUMIDITE';
                                    end
                                    if Affichage_zoom
                                        seuil_bas10=seuil_bas2;
                                        seuil_haut10=seuil_haut2;
                                    end
                                    LEG{1,1}='Temperature SHT 1';
                                    LEG{2,1}='Temperature SHT 2';
                                    LEG{3,1}='PT100';
                                    LEG{4,1}='Humidite SHT 1';
                                    LEG{5,1}='Humidite SHT 2';
                                    list_ind{1}=6;
                                    list_ind{2}=8;
                                    list_ind{3}=3;
                                    list_ind{4}=7;
                                    list_ind{5}=9;
                                    titre{1}='Temperature SHT 1';
                                    titre{2}='Temperature SHT 2';
                                    titre{3}='PT100';
                                    titre{4}='Humidite SHT 1';
                                    titre{5}='Humidite SHT 2';
                                    ylab{1}='°C';
                                    ylab{2}='°C';
                                    ylab{3}='°C';
                                    ylab{4}='%';
                                    ylab{5}='%';
                                    if sum(liste_TH(4:end))>=1 && sum(liste_TH(1:3))>=1
                                        nb_ligne=2;
                                        nb_col=max(sum(liste_TH(4:end)),sum(liste_TH(1:3)));
                                        offset=nb_col;
                                    else
                                        nb_ligne=1;
                                        nb_col=sum(liste_TH(:));
                                        offset=0;
                                    end
                                    for k_th=1:length(liste_TH)
                                        if liste_TH(k_th)==1   %===========================% fenetre 1
                                            if k_th<4
                                                nbrePlot=sum(liste_TH(1:k_th));
                                            else
                                                nbrePlot=offset+sum(liste_TH(4:k_th));
                                            end
                                            if k_th==3
                                                set(0,'CurrentFigure',fig5)
                                                subplot(nb_ligne,nb_col,nbrePlot);
                                                plot(tps(seuil_bas10:seuil_haut10),T2_temp(seuil_bas10:seuil_haut10,list_ind{k_th}),'-*')
                                                legend(LEG{k_th,1})
                                                hold off
                                                title(titre{k_th})
                                                xlabel('t en ms')
                                                ylabel(ylab{k_th})
                                            else
                                                set(0,'CurrentFigure',fig5)
                                                subplot(nb_ligne,nb_col,nbrePlot);
                                                plot(tps(seuil_bas10:seuil_haut10),TH_temp(seuil_bas10:seuil_haut10,list_ind{k_th}),'-*')
                                                legend(LEG{k_th,1:length(list_ind{k_th})})
                                                hold off
                                                title(titre{k_th})
                                                xlabel('t en ms')
                                                ylabel(ylab{k_th})
                                            end
                                        end
                                    end
                                end
                                
                                if Nombre_graph_AcclM>0
                                    list_ind={};
                                    LEG={};
                                    ylab={};
                                    if plot_on(6)==0
                                        fig6=figure(7);
                                        fig6.Name='Acceleration Motus';
                                    end
                                    if Affichage_zoom
                                        seuil_bas10=seuil_bas2;
                                        seuil_haut10=seuil_haut2;
                                    end
                                    LEG{1,1}='Accl X';
                                    LEG{2,1}='Accl Y';
                                    LEG{3,1}='Accl Z';
                                    list_ind{1}=2;
                                    list_ind{2}=3;
                                    list_ind{3}=4;
                                    ylab='m/s²';
                                    
                                    nb_ligne=1;
                                    nb_col=sum(liste_AccM(:));
                                    
                                    for k_m=1:length(liste_AccM)
                                        if liste_AccM(k_m)==1
                                            set(0,'CurrentFigure',fig6)
                                            subplot(nb_ligne,nb_col,k_m);
                                            plot(tps(seuil_bas10:seuil_haut10),Result.MOTUSRAW(seuil_bas10:seuil_haut10,list_ind{k_m}),'-*')
                                            legend(LEG{k_m,1})
                                            hold off
                                            xlabel('t em ms')
                                            ylabel(ylab)
                                        end
                                    end
                                end
                                
                                if Nombre_graph_Tpsmort>0
                                    list_ind={};
                                    LEG={};
                                    ylab={};
                                    if plot_on(7)==0
                                        fig7=figure(8);
                                        fig7.Name='Temps mort SD';
                                    end
                                    
                                    
                                    LEG{1,1}='variation numéro block SD';
                                    LEG{2,1}='variation cpt 100hz';
                                    LEG{3,1}='Tps mort instantanné';
                                    LEG{4,1}='Tps mort moyen';
                                    list_ind{1}=1;
                                    list_ind{2}=1;
                                    list_ind{3}=1;
                                    list_ind{4}=1;
                                    nb_ligne=1;
                                    nb_col=sum(liste_tpsmort(:));
                                    ylab{1}='deltaN';
                                    ylab{2}='deltacpt';
                                    ylab{3}='deltacpt/deltaN';
                                    ylab{4}='%';
                                    
                                    if Affichage_zoom
                                        seuil_bas10=seuil_bas2;
                                        seuil_haut10=seuil_haut2;
                                    end
                                    for k_m=1:length(liste_tpsmort)
                                        
                                        if liste_tpsmort(k_m)==1
                                            nb_plot=sum(liste_tpsmort(1:k_m));
                                            if k_m==1
                                                set(0,'CurrentFigure',fig7)
                                                subplot(nb_ligne,nb_col,nb_plot)
                                                plot(tps(seuil_bas10:seuil_haut10),BlockSD_temp(seuil_bas10:seuil_haut10,list_ind{k_m}),'-*')
                                                legend(LEG{k_m,1:length(list_ind{k_m})})
                                                hold off
                                                xlabel('t en ms')
                                                ylabel(ylab{k_m})
                                                
                                            elseif k_m==2
                                                set(0,'CurrentFigure',fig7)
                                                subplot(nb_ligne,nb_col,nb_plot)
                                                plot(tps(seuil_bas10:seuil_haut10),Cpt100hz_temp(seuil_bas10:seuil_haut10,list_ind{k_m}),'-*')
                                                legend(LEG{k_m,1:length(list_ind{k_m})})
                                                hold off
                                                xlabel('t en ms')
                                                ylabel(ylab{k_m})
                                                
                                            elseif k_m==3
                                                set(0,'CurrentFigure',fig7)
                                                subplot(nb_ligne,nb_col,nb_plot)
                                                plot(tps(seuil_bas10:seuil_haut10),Tps_mort(seuil_bas10:seuil_haut10,list_ind{k_m}),'-*')
                                                legend(LEG{k_m,1:length(list_ind{k_m})})
                                                hold off
                                                xlabel('t en ms')
                                                ylabel(ylab{k_m})
                                                
                                            elseif k_m==4
                                                set(0,'CurrentFigure',fig7)
                                                subplot(nb_ligne,nb_col,nb_plot)
                                                plot(tps(seuil_bas10:seuil_haut10),Tps_mort_moy(seuil_bas10:seuil_haut10,list_ind{k_m}),'-*')
                                                legend(LEG{k_m,1:length(list_ind{k_m})})
                                                hold off
                                                xlabel('t en ms')
                                                ylabel(ylab{k_m})
                                                
                                            end
                                            
                                        end
                                    end
                                end
                                
                                %
                                %
                            end
                            
                            j=j+1;
                            u=u+1;
                        else
                            fclose(s);
                            fopen(s);
                        end
                    end
                    timeout = timeout + 1;
                    pause(0.1);
%                     if ~type_ATP
%                         fopen(s);
%                     end
                    
                end
                
            end
            
            
            if Sauvegarde_Donnees
                if boucle2==12
                    
                    save(NomFichier,'suite_q','AD_NAVIGATION','IMU','PaquetAirData','PaquetWind','AirDataSensors',...
                        'Pattern','Pressures','TH','T2','MOTUSRAW','MOTUSORI','Q');
                    boucle2=1;
                else
                    boucle2=boucle2+1
                end
                
                
            end
            
        end
        
    end
end



%============= Fenetre ===============%
message0 = ' ';

message1 = sprintf('%sLe numero du port est: #%d\n',message0,Val_Com);

if AFF2D_Temp_Altitude
    message2 = sprintf('Affichage Temp/Altitude \n ');
else
    message2 = sprintf('Pas affichage Temp/Altitude \n ');
end

if AFF2D_Hum_Altitude
    message3 = sprintf('Affichage Hum/Altitude \n ');
else
    message3 = sprintf('Pas affichage Temp/Altitude \n ');
end

if Sauvegarde_Donnees
    message4 = sprintf('Sauvegarde donnees en cours \n ');
else
    message4 = sprintf('Pas de sauvegarde donnees en cours \n ');
end



end



