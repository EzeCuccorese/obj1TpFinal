import Rick.*

/* Las acciones que se realizan y el orden de las mismas se configuran al inicio 
 * del juego para cada instancia de un Parásito Alienígena con el cual se 
 * quiera jugar.*/
class Accion {
	/*Metodo abstracto para ejecutar las acciones. */
	method ejectuarAccion(unRecolector)
}

/* Que el recolector entregue todos sus elementos a su compañero */
class EntregarTodo inherits Accion {
	override method ejectuarAccion(unRecolector){
		unRecolector.darObjetosA(rick)
	}
}

/*Que el recolector descarte un elemento al azar de su mochila. Si la mochila está
vacía no descarta nada. */
class DescartarAlAzar inherits Accion{
	override method ejectuarAccion(unRecolector){
		unRecolector.tirarObjetoAlAzar()
	}
}

/* Incrementar o decrementar la energía del recolector. La cantidad de energía es un
 * porcentaje que debe ser configurado al momento de configurarse el parásito.
 * Distintos parásitos podrían tener distintos valores o incluso, un mismo parásito podría 
 * tener dos acciones de energía con valores distintos! (por ejemplo, restar el 10% , 
 * hacer algo más y luego sumar 5%) */
class IncrementarDecrementarEnergia inherits Accion {
	const energiaPorcentual
	constructor(unaEnergiaPorcentual){
		energiaPorcentual = unaEnergiaPorcentual
	}
	override method ejectuarAccion(unRecolector){
		unRecolector.modificarEnergiaPorcentual(energiaPorcentual)
	}
}

/* Que el recolector recolecte un elemento oculto. Al igual que en el punto anterior, 
 * el elemento que está oculto en esta acción se configura al inicio del juego. Un mismo parásito 
 * podría tener dos acciones distintas de este tipo, por ejemplo, una acción para recolectar 
 * un fleeb y una acción para recolectar una lata. Si el recolector no puede recolectar el 
 * elemento oculto, entonces no lo hace.
 */
class RecolectarElementoOculto inherits Accion {
	const elementoOculto
	
	constructor(unElementoOculto){
		elementoOculto = unElementoOculto
	}
	
	override method ejectuarAccion(unRecolector){
		unRecolector.recolectarSiPuede(elementoOculto)
	}
}

