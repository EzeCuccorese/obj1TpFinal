class Material {
	method gramosDeMetal() 
	method electricidad() = 0
	method esRadiactivo() = false
	method energia() = 0
	method esConductor() = self.electricidad() > 0
	method esGenerador() = self.energia() > 0
	method gramosDeMetalMayorA(unosGramos) = self.gramosDeMetal() > unosGramos
	
	method energiaRequerida() = self.gramosDeMetal()
	method efectoSobreRecolector(unRecolector){
		unRecolector.modificarEnergia(- self.energiaRequerida())		
	}
}

class Lata inherits Material {
	const gramos
	
	constructor(_gramos) {
		gramos = _gramos
	}
	override method gramosDeMetal() = gramos
	override method electricidad() = 0.1 * self.gramosDeMetal()
}

class Cable inherits Material {
	const longitud // en metros
	const seccion // en cm3

	constructor(_longitud, _seccion) {
		longitud = _longitud seccion = _seccion
	}
	override method gramosDeMetal() = ( longitud / 1000 ) * seccion
	override method electricidad() = 3 * seccion
}

class Fleeb inherits Material {
	const edad
	const estomago = #{ }

	constructor(_edad) {
		edad = _edad
	}
	method comer(unMaterial) {
		estomago.add(unMaterial)
	}
	override method gramosDeMetal() = if (estomago.isEmpty()) 0 else estomago.sum{ m => m.gramosDeMetal() }
	override method electricidad() = if (estomago.isEmpty()) 0 else estomago.map{ m => m.electricidad() }.min()
	override method esRadiactivo() = edad > 15
	override method energia() = if (estomago.isEmpty()) 0 else estomago.map{ m => m.energia() }.max()
	override method energiaRequerida() = super() * 2 
	 
	override method efectoSobreRecolector(unRecolector){
		super(unRecolector)
		if (!self.esRadiactivo()){
			unRecolector.modificarEnergia(10)	
		}
	}
}

class MateriaOscura inherits Material {
	const materialBase // Material de base

	constructor(_materialBase) {
		materialBase = _materialBase
	}
	override method gramosDeMetal() = materialBase.gramosDeMetal()
	override method electricidad() = materialBase.electricidad() / 2
	override method energia() = materialBase.energia() * 2
}

class MaterialDeExperimento inherits Material {
	const componentes
	constructor(_componentes) {
		componentes = _componentes
	}
	override method gramosDeMetal() = componentes.sum{ c => c.gramosDeMetal() }
}

class Bateria inherits MaterialDeExperimento {
	override method esRadiactivo() = true
	override method energia() = 2 * self.gramosDeMetal()
}

class Circuito inherits MaterialDeExperimento {
	override method electricidad() = 3 * componentes.sum{ c => c.electricidad() }
	override method esRadiactivo() = componentes.any{ c => c.esRadiactivo() }
}