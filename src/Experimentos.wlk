import Materiales.*

class Experimento {
	const condiciones
	constructor(_condiciones){
		condiciones = _condiciones
	}
	method puedeRealizarse(unRick) = condiciones.all{c => unRick.algunMaterialCumple(c) }
	method materialesParaConstruir(unRick) = condiciones.map{ c => unRick.algunMaterialQueCumpla(c) }
	method realizar(unRick){
		const materiales = self.materialesParaConstruir(unRick)
		unRick.remover(materiales) 
		self.aplicarEfecto(unRick, materiales)
	}
	method aplicarEfecto(unRick, unosMateriales)
}

object construirBateria inherits Experimento(#{self.gramosDeMetalNecesario(), self.esRadiactivo()}) {
// Se necesita un material que tenga más de 200 gramos de metal y un material radiactivo.
	const gramosDeMetalNecesarios = 200	
	
	method gramosDeMetalNecesario() = { m => m.gramosDeMetalMayorA(gramosDeMetalNecesarios) } 
	method esRadiactivo() = { m => m.esRadiactivo() }

	//* Al construirse el compañero de rick pierde 5 puntos de energía. 	 */
	override method aplicarEfecto(unRick, unosMateriales) {
		unRick.modificarEnergiaCompanero(-5) 
		unRick.agregar(new Bateria(unosMateriales))
	}
}

object construirCircuito inherits Experimento(#{self.conduccionNecesaria()}) {
	const conduccionNecesaria = 5
	// Requiere de al menos un material que conduzcan como mínimo 5 amperes. 	 	
	override method materialesParaConstruir(unRick) = condiciones.map{ c => unRick.todosMaterialesQueCumplen(c) }
	
	method conduccionNecesaria() = { m => m.electricidad() >= conduccionNecesaria }

	// El circuito es construido con todos los materiales que Rick tiene en la mochila que conducen al menos 5 amperes.	 */
	override method aplicarEfecto(unRick, unosMateriales) {
		unRick.agregar(new Circuito(unosMateriales))
	}
}

object shockElectrico inherits Experimento(#{self.esConductor(), self.esGenerador()}) {
	/*Sirve para incrementar la energía de su compañero. 
	 * Para eso se necesita un material capaz de generar energía (generador) 
	 * y otro capaz de conducirla (conductor). */	
	method esConductor() = { m => m.esConductor()} 
	method esGenerador() = { m => m.esGenerador()}
					
	method electricidadDeConductor(unosMateriales) = unosMateriales.anyOne(self.esConductor()).electricidad()
	method energiaDeGenerador(unosMateriales) = unosMateriales.anyOne(self.esGenerador()).energia()
			
	 /* Se incrementa la energía tanto como 
 		energía del generador * electricidad del conductor. */
	override method aplicarEfecto(unRick, unosMateriales) {
		unRick.modificarEnergiaCompanero(		
			self.electricidadDeConductor(unosMateriales)
			* self.energiaDeGenerador(unosMateriales) 
			)
	}
}