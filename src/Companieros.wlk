class Companiero {
}

object morty inherits Companiero {
	var energia
	const mochila = #{ } // No puede tener mas de 3
	
	method modificarEnergia(unaCantidad) {
		energia = ( energia + unaCantidad ).max(0)
	} 
	
	method puedeRecolectar(unMaterial) = mochila.size() < 3 and energia >= unMaterial.energiaRequerida()
	
	method validarRecoleccion(unMaterial) {
		if (mochila.size() >= 3) {
			self.error("Morty tiene la mochila llena!")
		}
		
		if (! self.puedeRecolectar(unMaterial)){
			self.error("No hay energia suficiente para recolectar " + unMaterial)
		}
	}
	
	method recolectar(unMaterial) {
		self.validarRecoleccion(unMaterial)
		mochila.add(unMaterial)
		energia -= unMaterial.energiaRequerida()
		energia += unMaterial.energiaQueAporta()
	}
	
	method darObjetosA(unCompanero) {
		unCompanero.recibir(mochila)
		mochila.clear()
	}
}