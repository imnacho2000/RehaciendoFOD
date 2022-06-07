program parcial;
const
    valor_corte = '9999';
type
    acceso = record
        anio: String[25];
        mes: String[25];
        dia : String[25];
        idUsuario: integer;
        tiempo: integer;
    end;

    archivo_maestro = file of acceso;

    procedure leer(var archivoM: archivo_maestro; var reg_m: acceso);
    begin
        if not eof(archivoM) then 
            read(archivoM,reg_m)
        else
            reg_m.anio := valor_corte;
    end;

    procedure generar_informe(var archivoM: archivo_maestro; anio: string);
    var
        tiempo_anio , tiempo_total_diario , total_tiempo_mes , tiempo_total_por_usuario: integer;
        reg_m,anio_aux,mes_aux,dia_aux,idUsuario_aux: acceso;
    begin
        reset(archivoM);
        leer(archivoM,reg_m);
        while( (reg_m.anio <> anio ) and (reg_m.anio <> valor_corte )) do begin
            leer(archivoM,reg_m);
        end;

        if(reg_m.anio = anio) then begin
            anio_aux.anio := reg_m.anio;
            tiempo_anio:= 0;
            while(reg_m.anio <> valor_corte) do begin
                write('Anio: ', reg_m.anio);
                mes_aux.mes := reg_m.mes;
                total_tiempo_mes:= 0;
                while((anio_aux.anio = reg_m.anio) and (reg_m.mes = mes_aux.mes)) do begin
                    tiempo_total_diario := 0;
                    write('Mes: ', mes_aux.mes);
                    dia_aux.dia := reg_m.dia;
                    while((anio_aux.anio = reg_m.anio) and (reg_m.mes = mes_aux.mes) and (reg_m.dia = dia_aux.dia)) do begin
                        tiempo_total_por_usuario:= 0;
                        write('Dia: ', reg_m.dia);
                        idUsuario_aux.idUsuario := reg_m.idUsuario;
                        write('Id usuario: ', reg_m.idUsuario);
                        while((anio_aux.anio = reg_m.anio) and (reg_m.mes = mes_aux.mes) and (reg_m.dia = dia_aux.dia) and (reg_m.idUsuario = idUsuario_aux.idUsuario)) do begin
                            tiempo_total_por_usuario:= tiempo_total_por_usuario + reg_m.tiempo;
                            leer(archivoM,reg_m);
                        end;
                        write('Tiempo total de acceso en el dia: ', reg_m.dia,' Mes: ',reg_m.mes,' : ',tiempo_total_por_usuario);
                        tiempo_total_diario:= tiempo_total_diario + tiempo_total_por_usuario;
                    end;
                    write('Tiempo total acceso dia: ', reg_m.dia,' Mes: ',reg_m.mes,' : ', tiempo_total_diario);
                    total_tiempo_mes:= total_tiempo_mes + tiempo_total_diario;
                end;
                write('Total tiempo de acceso: ', total_tiempo_mes, ' Mes:', reg_m.mes);
                tiempo_anio:= tiempo_anio + total_tiempo_mes;
            end;
            write('Total tiempo de acceso ano: ', tiempo_anio)
        end
        else
            write('el anio ', anio,' no se encontro en el archivo.');
        close(archivoM);
    end;

var
    archivoM: archivo_maestro;
    anio: string[25];
    ok: boolean;
begin
    ok:= False;
    Assign(archivoM,'maestro');
    write('Ingrese anio para generar informe: ');
    readln(anio);
    generar_informe(archivoM,anio);
end.