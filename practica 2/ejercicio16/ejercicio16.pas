{
    
    La editorial X, autora de diversos semanarios, posee un archivo maestro con la
    información correspondiente a las diferentes emisiones de los mismos. De cada emisión se
    registra: fecha, código de semanario, nombre del semanario, descripción, precio, total de
    ejemplares y total de ejemplares vendido.
    Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
    país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
    cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
    procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
    actualización del archivo maestro en función de las ventas registradas. Además deberá
    informar fecha y semanario que tuvo más ventas y la misma información del semanario con
    menos ventas.
    Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
    ventas de semanarios si no hay ejemplares para hacerlo

}
program ej16;
const
    valor_alto = 'ZZZZ';
    cant=100;
type

    reg_maestro=record
        fecha:fechas;
        cod:integer;
        nombre: string;
        descripcion: string;
        precio:real;
        total:integer;
        total_vendidos:integer;
    end;

    reg_detalle = record
        fecha: string;
        cod: integer;
        vendidos: integer;
    end;

    maestro = file of reg_maestro;
    detalle = file of detalle;

    vec_det = array [1..cant] of reg_detalle;
    reg_det = array [1..cant] of detalle;



    procedure leer (var arc_detalle:detalle; var dato:cDetalle);
    begin
        if not eof (arc_detalle) then
            read (arc_detalle,dato)
        else
            dato.fecha := valorAlto;
    end;



    procedure actualizar_maestro(var m:maestro; var d:detalle; asientos:integer);
    var  
        registros: arreglo_registro_detalle;
        regM: vuelo; 
        min: detalle;
        i,total_asientos:integer;
    begin
        for i:= 1 to cant_detalles do begin
            reset(d);
            leer(d[i],registros[i]);
        end;
        reset(m);
        minimo(d,registros,min);
        while(min.destino <> valor_alto) do begin
            total_asientos:=0;
            read(m,regM);
            while(regM.destino <> min.destino) do
                read(m,regM);
            
            while (regM.destino = min.destino) and (regM.fecha.dia = min.fecha.dia) and (regM.fecha.mes = min.fecha.mes) and (regM.fecha.anio = min.fecha.anio) and (regM.hora = min.hora) do begin
                total_asientos:= total_asientos + min.cant_asientos;
                minimo(d,registros,min);
            end;
            regM.cant_asientos := regM.cant_asientos - total_asientos;
            seek(m,filepos(m)-1);
            write(m,regM);

            if(asientos > regM.cant_asientos) then
                imprimir_registro(regM);
        end;
        for i:= 1 to cant_detalles do begin
            close(d[i]);
        end;
        close(m);
    end;


    procedure minimo (var det:vec_det; var min: reg_detalle; var reg_vect:reg_det );
    var
        indicice_minimo,i:integer;
    begin
        min.fecha := valor_alto;
        min.cod := 9999;
        indice_minimo := 1;
        for i:= 1 to cant do begin
            if (reg_maestro[i].fecha < min.fecha) then 
                if (reg_maestro[i].cod < min.cod) then begin
                    min:=registros[i];
                    indice_minimo:= i;
                end;
        end;

        if (min.fecha <> valor_alto ) then  
            leer(det[indice_minimo],reg_maestro[indice_minimo]);
    end;

    procedure actualizar_maestro(var m:maestro; var d: vec_det);
    var
        max,min,i:integer;
        registros: arreglo_registro_detalle;
        max,min,regM: reg_maestro;
        min: reg_detalle;
    begin


    end;

var
    arch_maestro : maestro;
    m:reg_maestro;


begin

end.