class Companiero {
}

object morty inherits Companiero {
	var energia
	const mochila = #{} // No puede tener mas de 3
	
	method modificarEnergia(unaCantidad) {
		energia = ( energia + unaCantidad ).max(0)
	} 
	
	method hayLugarEnMochila() = mochila.size() < 3
	method energiaSuficienteParaRecolectar(unMaterial) = energia >= unMaterial.energiaRequerida()
	
	method puedeRecolectar(unMaterial) = self.hayLugarEnMochila() and self.energiaSuficienteParaRecolectar(unMaterial)
		
	method recolectar(unMaterial) {
		if (!self.puedeRecolectar(unMaterial)){
			self.error("No se puede recolectar " + unMaterial)
		}
		mochila.add(unMaterial)
		energia -= unMaterial.energiaRequerida()
		energia += unMaterial.energiaQueAporta()
	}
	
	method darObjetosA(unCompanero) {
		unCompanero.recibir(mochila)
		mochila.clear()
	}
}