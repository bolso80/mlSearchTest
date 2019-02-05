# mlSearchTest

### ERRORES CONOCIDOS
- En el caso de que no correspondan a toda la busqueda (campos que no se pueden leer):
										No se carga ese item de la busqueda y se crea un crash non fatal en crashlytics con el id del item y datos que ayuden a resolver el problema.

- En el caso de errores que impidan la busqueda devuelvo un mensaje de error:
 										-- FALTA DE CONEXION: Se sugiere al usuario revisar su conexion
 										-- ERROR EN EL PARSEO DEL RESULTADO DE LA BUSQUEDA: Se crea un crash non fatal en crashlytics para que quede registro del problema y asi poder resolverlo el departamento correspondiente y se avisa al usuario de que intente la busqueda nuevamente.

 ### ERRORES NO CONOCIDOS
 - Para los errores no conocidos se instalo Crashlytics para tener una herramienta que loguee los mismos y ademas se agregaron logs en el transcurso del flujo de la app para que en caso de tener un crash poder identificar la razon con mayor facilidad y resolverlo.