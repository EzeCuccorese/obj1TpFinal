import Materiales.*

/*Representa un experimento con todos los mensajes que entienden */
class Experimento {
	
	//Condiciones para realizar el experimento (conjunto de clousures).
	const condiciones
	
	//Cuando se construye un nuevo experimento, se le debe pasar las condiciones.
	constructor(_condiciones){
		condiciones = _condiciones
	}
	
	/*Verifica si se cumplen todas las condicones necesarias para realizar el experimento */
	method puedeRealizarse(unRick) = condiciones.all{c => unRick.algunMaterialCumple(c) }
	
	/*Le pide al cientifico los materiales para construir. */
	method materialesParaConstruir(unRick) = 
			condiciones.map{ c => unRick.algunMaterialQueCumpla(c) }
	
	/*Realiza el procedimiento necesario para llevar a cabo el experimento. */
	method realizar(unRick){
		//Se guardan los materiales en una constante ya que los metodos de colecciones "anyOne" no
		//aseguran que los materiales sean los mismos con los que se llevo la validacion 
		//de condiciones en un principio.
		
		const materiales = self.materialesParaConstruir(unRick)
		unRick.remover(materiales) 
		self.aplicarEfecto(unRick, materiales)
	}
	
	/*Aplica un efecto sobre el companiero de rick luego de realizar el experimento. */
	method aplicarEfecto(unRick, unosMateriales)
}

/* Implentacion de la construccion de una bateria. Tiene como condiciones que los materiales deben
 * tener una cierta cantidad de gramos de metal y/o el material debe ser radiactivo.
 */
object construirBateria inherits 
					Experimento(#{self.gramosDeMetalNecesario(), self.esRadiactivo()}) {
						
	// Cantidad de gramos de metal necesarios que debe tener el material.
	const gramosDeMetalNecesarios = 200	
	
	/*Validacion sobre el material para ver si cumple con los gramos de metal necesarios */
	method gramosDeMetalNecesario() = { m => m.gramosDeMetalMayorA(gramosDeMetalNecesarios) }
	
	/*Verificacion sobre el material para ver si es radiactivo. */ 
	method esRadiactivo() = { m => m.esRadiactivo() }

	/* Sobreescritura del metodo aplicar efecto al construir una bateria. En este caso al 
	 * construirse el compañero de rick pierde 5 puntos de energía.
	 */
	override method aplicarEfecto(unRick, unosMateriales) {
		unRick.modificarEnergiaCompanero(-5) 
		unRick.agregar(new Bateria(unosMateriales))
	}
}

/* Implentacion de la construccion de un circuito. Tiene como condiciones que los materiales 
 * tengan la conduccion necesaria para realizar el experimento.
 */
object construirCircuito inherits Experimento(#{self.conduccionNecesaria()}) {
	
	//Cantidad de conduccion necesaria que debe tener el material.
	const conduccionNecesaria = 5
	
	/*Se sobreescribe este metodo, ya que para construir un circuito se ocupan 
	 * todos los materiales que cumplan con la condicion. */
	override method materialesParaConstruir(unRick) = 
				condiciones.map{ c => unRick.todosMaterialesQueCumplen(c) }
				
	/*Verifica que el material tenga la conduccion necesaria para realizar el experimento. */
	method conduccionNecesaria() = { m => m.electricidad() >= conduccionNecesaria }

	/* Sobreescritura del metodo aplicar efecto al construir un circuito. En este caso al 
	 * construirse no se aplica ningun efecto sobre el compaiero de rick.
	 */
	override method aplicarEfecto(unRick, unosMateriales) {
		unRick.agregar(new Circuito(unosMateriales))
	}
}

/* Implentacion de la construccion de shock electrico. Sirve para incrementar la energia del 
 * companiero. Para eso se necesita un material capaz de generar energia (generador) 
 * y otro capaz de conducirla (conductor).
 */
object shockElectrico inherits Experimento(#{self.esConductor(), self.esGenerador()}) {
	
	/*Verifica que el material sea conductor de energia.*/
	method esConductor() = { m => m.esConductor()}
	
	/*Verifica que el material sea generador de energia. */ 
	method esGenerador() = { m => m.esGenerador()}
	
	/*Devuelve la electricidad del material conductivo. */				
	method electricidadDeConductor(unosMateriales) = 
				unosMateriales.anyOne(self.esConductor()).electricidad()
	
	/* Devuelve la energia del material energetico. */
	method energiaDeGenerador(unosMateriales) =
				unosMateriales.anyOne(self.esGenerador()).energia()

	/* Sobreescritura del metodo aplicar efecto al construir un shock electrico. En este caso 
	 * el companiero gana la energia que da el conductor por el generador.
	 */	
	override method aplicarEfecto(unRick, unosMateriales) {
		unRick.modificarEnergiaCompanero(		
			self.electricidadDeConductor(unosMateriales)
			* self.energiaDeGenerador(unosMateriales) 
			)
	}
}