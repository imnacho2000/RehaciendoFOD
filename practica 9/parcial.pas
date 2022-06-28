program parcial;
const
    valor_alto = 9999;
type

    prenda = record
        cod_prenda: integer;
        descripcion: string[25];
        colores: string[25];
        tipo_prenda: string[25];
        stock: integer;
        precio_unitario: real;
    end;


    recibido = record
        cod_prenda: integer;
    end;

    archivo_maestro = file of prenda;
    archivo_detalle = file of recibido;

    procedure leer(var archivo: archivo_detalle; var regD: recibido);
    begin
        if not eof(archivo) then
            read(archivo,regD)
        else
            regD.cod_prenda := valor_alto;

    end;



    procedure baja(var m:archivo_maestro; var d:archivo_detalle);
    var
        regD: recibido;
        regM: prenda;
        aux_pos:integer;
    begin
        reset(m);
        reset(d);
        read(m,regM);
        leer(d,regD);
        while(regD.cod_prenda <> valor_corte) do begin
            
            while (regM.cod_prenda <> regD.cod_prenda) do 
                read(m,regM)

            while (regM.cod_prenda =  regD.cod_prenda) do begin
                regM.stock := (regM.stock * -1);
                leer(d,regD);
            end;

            seek(m,filepos(m)-1);
            write(m,regM);
            seek(m,0);
        end;

        seek(m,0);    
        read(m,reg_m);
        
            


        end;
        close(m);           
        close(d);
    end;
    


var

begin

end.