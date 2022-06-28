program parcial;
const
    valor_alto = 9999;
    cant_detalles = 30;
type

    farmaco = record
        cod_farmaco: integer;
        nombre: string[25];
        fecha: string[10];
        cant_vendida: integer;
        forma_pago: string;
    end;

    archivo_detalle = file of farmaco;
    
    arreglo_archivo_detalle = array [1..cant_detalles] of archivo_detalle;
    
    arreglo_registro_detalle = array [1..cant_detalles] of farmaco;


    procedure leer(var archivoD: archivo_detalle; var reg_d: farmaco);
    begin
        if not eof(archivoD) then
            read(archivoD,reg_d)
        else
            reg_d.cod_farmaco := valor_alto;
    end;

    procedure minimo(var archivoD: arreglo_archivo_detalle; var arreglo_regD:arreglo_registro_detalle ;var min: farmaco);
    var
        minPos,i:integer;
    begin
        min.cod_farmaco:=9999;
        min.fecha:= '99/99/9999';
        minPos:= 1;
        for i:= 1 to cant_detalles do begin
            if(arreglo_regD[i].cod_farmaco < min.cod_farmaco) then 
                if(arreglo_regD[i].fecha < min.fecha) then begin
                    min := arreglo_regD[i];
                    minPos := i;
                end;
        end;

        if(min.cod_farmaco <> valor_alto) then
            leer(archivoD[minPos],arreglo_regD[minPos]);
    end;

    procedure imprimir_registro(var reg_d: farmaco);
    begin
        write('Codigo: ', reg_d.cod_farmaco, #10, 'Nombre: ', reg_d.nombre, #10, 'Fecha: ', reg_d.fecha, #10,'Cantidad vendida: ', reg_d.cant_vendida, #10,'Forma de pago: ', reg_d.forma_pago, #10);
    end;

    procedure mas_ventas(var archivoD: arreglo_archivo_detalle);
    var
        arreglo_regD:arreglo_registro_detalle;
        cant_max,i: integer;
        reg_d,reg_aux,reg_max: farmaco;
    begin

        for i:= 1 to cant_detalles do begin
            reset(archivoD[i]);
            leer(archivoD[i],arreglo_regD[i]);
        end;
        
        cant_max := -1;
        minimo(archivoD,arreglo_regD,reg_d);
        while(reg_d.cod_farmaco <> valor_alto) do begin
            reg_aux.cod_farmaco := reg_d.cod_farmaco;
            reg_aux.cant_vendida := reg_d.cant_vendida;
            
            while(reg_aux.cod_farmaco = reg_d.cod_farmaco) and (reg_aux.fecha = reg_d.fecha) do begin
                reg_aux.cant_vendida := reg_aux.cant_vendida + reg_d.cant_vendida;
                minimo(archivoD,arreglo_regD,reg_d);
            end;

            if(reg_aux.cant_vendida > cant_max) then begin
                reg_max := reg_aux;
                cant_max:= reg_aux.cant_vendida;
            end;
        end;
        imprimir_registro(reg_max);
        
        for i:= 1 to cant_detalles do begin
            close(archivoD[i]);
        end;
    end;

    
    procedure mas_fecha(var archivoD: arreglo_archivo_detalle);
    var
        cod,cantMax, cantAct, i: integer;
        fechaAct, fechaMax: String[10];
        act: farmaco;
        arreglo_regD: arreglo_registro_detalle;
    begin
        
        for i:= 1 to cant_detalles do begin
            reset(archivoD[i]);
            leer(archivoD[i], arreglo_regD[i]);
        end;
        
        minimo(archivoD,arreglo_regD,act);
        cantMax:= -1;
        
        while (act.cod_farmaco <> valor_alto) do begin                
            
            fechaAct:= act.fecha;
            cantAct:= 0;
            cod:= act.cod_farmaco;
            
            while ((fechaAct = act.fecha) and (act.cod_farmaco = cod)) do begin
                if (act.forma_pago = 'contado') then begin
                    cantAct:= cantAct + 1;
                end;
                minimo(archivoD,arreglo_regD,act);
            end;
            
            if (cantAct > cantMax) then begin
                cantMax:= cantAct;
                fechaMax:= fechaAct;
            end;
        end;

        for i:= 1 to cant_detalles do begin
            close(archivoD[i]);
        end;

        writeLn('El día ', fechaMax, ', se vendieron ', cantMax, ' farmacos.')
    end;     

    procedure resumenVentas(var v: arreglo_archivo_detalle; var txt: Text);
    var
        aux: arreglo_registro_detalle;
        min: farmaco;
        act: farmaco;
        i,total_farmaco_act: integer;

    begin
        rewrite(txt);
        for i:= 1 to cant_detalles do begin
            reset(v[i]);
            leer(v[i], aux[i]);
        end;

        minimo(v, aux, min);
        while(min.cod_farmaco <> valor_alto)do begin
            act:=min;
            total_farmaco_act := 0;
            while(act.cod_farmaco = min.cod_farmaco)and(act.fecha = min.fecha) do begin
                total_farmaco_act := total_farmaco_act + min.cant_vendida;
                minimo(v, aux, min);
            end;
            writeln(txt, ' codigo: ', act.cod_farmaco, ' nombre: ', act.nombre, ' fecha: ', act.fecha, ' total vendido: ', total_farmaco_act);
        end;
        for i:=1 to cant_detalles do 
            close(v[i]);
        close(txt);
    end;


