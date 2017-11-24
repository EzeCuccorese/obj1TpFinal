import Materiales.*

/*Representa un experimento con todos los mensajes que entienden 
 * Clase Abstracta */
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
			
	/*Remover materiales de rick, y aplicar efecto */
	method removerYAplicarEfecto(unRick, unosMateriales){
		unRick.remover(unosMateriales) 
		self.aplicarEfecto(unRick, unosMateriales)
	}
	
	/*Realiza el procedimiento necesario para llevar a cabo el experimento. */
	method realizar(unRick){
		self.removerYAplicarEfecto(unRick, self.materialesParaConstruir(unRick))
	}
	
	/*Aplica un efecto sobre el companiero de rick luego de realizar el experimento. 
	 * Metodo Abstracto  */
	method aplicarEfecto(unRick, unosMateriales)
}

/* Implentacion de la construccion de una bateria. Tiene como condiciones que los materiales deben
 * tener una cierta cantidad de gramos de metal y/o el material debe ser radiactivo.
 */
object construirBateria inherits Experimento(#{
	/*Validacion sobre el material para ver si cumple con los gramos de metal necesarios */					
	{ m => m.gramosDeMetalMayorA(200) },  
	/*Verificacion sobre el material para ver si es radiactivo. */ 
	{ m => m.esRadiactivo() }
	}) {
		
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
object construirCircuito inherits Experimento(#{
	/*Verifica que el material tenga la conduccion necesaria para realizar el experimento. */
	{ m => m.electricidad() >= 5 }}) {
	
	/*Se sobreescribe este metodo, ya que para construir un circuito se ocupan 
	 * todos los materiales que cumplan para cada una de las condiciones. */
	override method materialesParaConstruir(unRick) = 
		condiciones.map{c => unRick.todosMaterialesQueCumplen(c) }.flatten()

	/* Sobreescritura del metodo aplicar efecto al construir un circuito. En este caso al 
	 * construirse no se aplica ningun efecto sobre el compaiero de rick. */
	override method aplicarEfecto(unRick, unosMateriales) {
		unRick.agregar(new Circuito(unosMateriales))
	}
}

/* Implentacion de la construccion de shock electrico. Sirve para incrementar la energia del 
 * companiero. Para eso se necesita un material capaz de generar energia (generador) 
 * y otro capaz de conducirla (conductor).
 */
object shockElectrico inherits Experimento(#{
	/*Verifica que el material sea conductor de energia.*/
	{ m => m.esConductor()}, 
	/*Verifica que el material sea generador de energia. */ 
	{ m => m.esGenerador()}
}) {
	
	/*Verifica que el material sea conductor de energia.*/
	const esConductor = { m => m.esConductor()}
	
	/*Verifica que el material sea generador de energia. */ 
	const esGenerador = { m => m.esGenerador()}
	
	/*Denota algun objeto de unosMateriales que cumpla la condicion "condicion" */
	method algunoQueCumpla(unosMateriales, condicion) =
			unosMateriales.filter(condicion).anyOne()  
	
	/*Devuelve la electricidad del material conductivo. */				
	method electricidadDeConductor(unosMateriales) =
		self.algunoQueCumpla(unosMateriales, esConductor).electricidad()
	
	/* Devuelve la energia del material energetico. */
	method energiaDeGenerador(unosMateriales) =
		self.algunoQueCumpla(unosMateriales, esGenerador).energia()

	/* Sobreescritura del metodo aplicar efecto al construir un shock electrico. 
	 * En este caso el companiero gana la energia que da el conductor 
	 * multiplicado la electricidad del generador.
	 */	
	override method aplicarEfecto(unRick, unosMateriales) {
		unRick.modificarEnergiaCompanero(		
			self.electricidadDeConductor(unosMateriales)
			* self.energiaDeGenerador(unosMateriales) 
			)
	}
}