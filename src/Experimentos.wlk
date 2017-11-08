import Materiales.*
 
//EXPERIMENTOS

class Experimento {
	method puedeRealizarse(mochila)
	method materialesParaConstruir(mochila) 
	method construir(unRick) }

object construirBateria inherits Experimento {
// Se necesita un material que tenga más de 200 gramos de metal y un material radiactivo.	 
	override method puedeRealizarse(mochila) = 
						mochila.any{ m => m.gramosDeMetal() > 200 } 
						and mochila.any{ m => m.esRadiactivo() }
	
	
	override method materialesParaConstruir(mochila) = #{ 
			mochila.anyOne{ m => m.gramosDeMetal() > 200 } } 
			+ #{ mochila.anyOne{ m => m.esRadiactivo() } }

	//* Al construirse el compañero de rick pierde 5 puntos de energía. 	 */
	override method construir(unRick) {
		unRick.companero().restarEnergia(5)
		unRick.agregar(
			new Bateria(
				self.materialesParaConstruir(unRick.mochila())
			)
		)
	}
}

object construirCircuito inherits Experimento {

	// Requiere de al menos un material que conduzcan como mínimo 5 amperes. 	 
	override method puedeRealizarse(mochila) = !self.materialesParaConstruir(mochila).isEmpty()
	
	override method materialesParaConstruir(mochila) = mochila.filter{ m => m.electricidad() >= 5 }

	// El circuito es construido con todos los materiales que Rick tiene en la mochila que conducen al menos 5 amperes.	 */
	override method construir(unRick) {
		unRick.agregar(
			new Circuito(
				self.materialesParaConstruir(unRick.mochila())
			)
		)
	}
}

object shockElectrico inherits Experimento {
	/*Sirve para incrementar la energía de su compañero. 
	 * Para eso se necesita un generador eléctrico y un material conductivo. 
	 * Se incrementa la energía en tantos puntos como la capacidad del generador eléctrico * la capacidad conductiva del conductor.	*/
	override method puedeRealizarse(mochila) = 
					mochila.any{ m => m.esConductivo()} 
					and mochila.any{ m => m.esGenerador() }
					
	override method materialesParaConstruir(mochila) = #{ 
					mochila.anyOne{ m => m.esConductivo() } } 
					+ #{ mochila.anyOne{ m => m.esGenerador() } }

	override method construir(unRick) {
		unRick.companero().sumarEnergia(
			unRick.mochila().anyOne{ m => m.esConductivo() }.electricidad() 
			* unRick.mochila().anyOne{ m =>	m.esGenerador() }.energia())
	}
}