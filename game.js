// Configuración del Juego
const GAME_CONFIG = {
    gridWidth: 20,
    gridHeight: 15,
    tileSize: 40,
    updateInterval: 1000
};

// Estado del Juego
let gameState = {
    isPaused: false,
    gameSpeed: 1,
    currentDay: 1,
    currentMonth: 1,
    currentYear: 1,
    resources: {
        gold: 1000,
        wood: 500,
        stone: 300,
        food: 200,
        water: 100,
        electricity: 50
    },
    maxElectricity: 100,
    population: 1000,
    happiness: 0.8,
    pollution: 0.2,
    cityLevel: 1,
    prestige: 0,
    buildings: [],
    selectedBuilding: null
};

// Costos de Edificios
const BUILDING_COSTS = {
    residence: 100,
    factory: 300,
    park: 50,
    power: 500,
    hospital: 400,
    school: 250,
    road: 20, // costo bajo para carreteras
    tree: 0,   // decoración
    rock: 0    // decoración
};

// Información de Edificios
const BUILDING_INFO = {
    residence: {
        name: 'Residencia',
        icon: '🏠',
        description: 'Alberga población'
    },
    factory: {
        name: 'Fábrica',
        icon: '🏭',
        description: 'Produce madera y piedra'
    },
    park: {
        name: 'Parque',
        icon: '🌳',
        description: 'Aumenta la felicidad'
    },
    power: {
        name: 'Central Eléctrica',
        icon: '⚡',
        description: 'Produce electricidad'
    },
    hospital: {
        name: 'Hospital',
        icon: '🏥',
        description: 'Mejora la salud'
    },
    school: {
        name: 'Escuela',
        icon: '🎓',
        description: 'Educa la población'
    },
    road: {
        name: 'Carretera',
        icon: '🛣️',
        description: 'Conecta áreas'
    },
    tree: {
        name: 'Árbol',
        icon: '🌲',
        description: 'Elemento decorativo'
    },
    rock: {
        name: 'Roca',
        icon: '🪨',
        description: 'Decoración'
    }
};

// Inicializar el Juego
document.addEventListener('DOMContentLoaded', function() {
    initializeGame();
    setupEventListeners();
    startGameLoop();
});

function initializeGame() {
    // Inicializar el mapa
    initializeMap();
    
    // Generar una ciudad básica al inicio (residencias, carreteras y algunos objetos)
    generateCity();
    
    // Actualizar UI
    updateGameUI();
    
    // Dibujar mini-mapa
    drawMiniMap();
    
    console.log('✅ Juego inicializado correctamente');
}

// crea o re-crea un conjunto inicial de edificios/objetos en el mapa
function generateCity() {
    // limpiar cualquier construcción previa
    gameState.buildings = [];
    document.querySelectorAll('.building-tile').forEach(el => el.remove());

    // ejemplo sencillo: dos calles en cruz, unas residencias y un parque
    const initialLayouts = [
        { type: 'road', x: 0, y: 7 },
        { type: 'road', x: 1, y: 7 },
        { type: 'road', x: 2, y: 7 },
        { type: 'road', x: 3, y: 7 },
        { type: 'road', x: 4, y: 7 },
        { type: 'road', x: 5, y: 7 },
        { type: 'road', x: 6, y: 7 },
        { type: 'road', x: 7, y: 7 },
        { type: 'road', x: 8, y: 7 },
        { type: 'road', x: 9, y: 7 },
        { type: 'road', x: 10, y: 7 },
        { type: 'road', x: 11, y: 7 },
        { type: 'road', x: 12, y: 7 },
        { type: 'road', x: 13, y: 7 },
        { type: 'road', x: 14, y: 7 },
        { type: 'road', x: 15, y: 7 },
        { type: 'road', x: 16, y: 7 },
        { type: 'road', x: 17, y: 7 },
        { type: 'road', x: 18, y: 7 },
        { type: 'road', x: 19, y: 7 },
        { type: 'road', x: 10, y: 0 },
        { type: 'road', x: 10, y: 1 },
        { type: 'road', x: 10, y: 2 },
        { type: 'road', x: 10, y: 3 },
        { type: 'road', x: 10, y: 4 },
        { type: 'road', x: 10, y: 5 },
        { type: 'road', x: 10, y: 6 },
        { type: 'road', x: 10, y: 7 },
        { type: 'road', x: 10, y: 8 },
        { type: 'road', x: 10, y: 9 },
        { type: 'road', x: 10, y: 10 },
        { type: 'road', x: 10, y: 11 },
        { type: 'road', x: 10, y: 12 },
        { type: 'road', x: 10, y: 13 },
        { type: 'road', x: 10, y: 14 },
        { type: 'residence', x: 8, y: 5 },
        { type: 'residence', x: 9, y: 5 },
        { type: 'residence', x: 11, y: 5 },
        { type: 'residence', x: 12, y: 5 },
        { type: 'park', x: 9, y: 6 },
        { type: 'park', x: 11, y: 6 },
        // algunos objetos decorativos
        { type: 'tree', x: 5, y: 10 },
        { type: 'tree', x: 14, y: 3 },
        { type: 'rock', x: 2, y: 12 },
        { type: 'rock', x: 17, y: 8 }
    ];

    initialLayouts.forEach(b => {
        b.health = 100;
        gameState.buildings.push(b);
        renderBuilding(b);
    });

    updateGameUI();
    drawMiniMap();
}


function initializeMap() {
    const gameMap = document.getElementById('gameMap');
    const mapGrid = gameMap.querySelector('.map-grid');
    
    // Crear grid visual
    for (let i = 0; i < GAME_CONFIG.gridWidth * GAME_CONFIG.gridHeight; i++) {
        const tile = document.createElement('div');
        tile.className = 'map-tile';
        tile.dataset.x = i % GAME_CONFIG.gridWidth;
        tile.dataset.y = Math.floor(i / GAME_CONFIG.gridWidth);
        
        tile.addEventListener('click', (e) => handleMapClick(e, tile));
        
        mapGrid.appendChild(tile);
    }
}

function setupEventListeners() {
    // Botones de control
    document.getElementById('pauseBtn').addEventListener('click', togglePause);
    document.getElementById('speedBtn').addEventListener('click', changeGameSpeed);
    document.getElementById('settingsBtn').addEventListener('click', openSettings);
    document.getElementById('generateBtn').addEventListener('click', generateCity);
    
    // Botones de construcción
    document.querySelectorAll('.building-btn').forEach(btn => {
        btn.addEventListener('click', selectBuilding);
    });
    
    // Modal settings
    document.querySelector('.close').addEventListener('click', closeSettings);
    window.addEventListener('click', (e) => {
        const modal = document.getElementById('settingsModal');
        if (e.target == modal) closeSettings();
    });
}

function selectBuilding(e) {
    const btn = e.currentTarget;
    const buildingType = btn.dataset.building;
    
    // Remover selección anterior
    document.querySelectorAll('.building-btn').forEach(b => b.classList.remove('selected'));
    
    // Seleccionar nuevo
    btn.classList.add('selected');
    
    // Actualizar estado
    gameState.selectedBuilding = buildingType;
    
    // Actualizar info
    const buildingInfo = BUILDING_INFO[buildingType];
    document.getElementById('selectedBuilding').textContent = 
        `${buildingInfo.icon} ${buildingInfo.name} - ${buildingInfo.description}`;
}

function handleMapClick(e, tile) {
    if (!gameState.selectedBuilding) return;
    
    const x = parseInt(tile.dataset.x);
    const y = parseInt(tile.dataset.y);
    const buildingType = gameState.selectedBuilding;
    const cost = BUILDING_COSTS[buildingType];
    
    // Verificar si hay dinero
    if (gameState.resources.gold < cost) {
        showNotification('❌ No tienes suficiente dinero!', 'warning');
        return;
    }
    
    // Verificar si la casilla está vacía
    const existingBuilding = gameState.buildings.find(b => b.x === x && b.y === y);
    if (existingBuilding) {
        showNotification('⚠️ Ya hay un edificio aquí', 'warning');
        return;
    }
    
    // Construir
    gameState.resources.gold -= cost;
    
    const building = {
        type: buildingType,
        x: x,
        y: y,
        health: 100
    };
    
    gameState.buildings.push(building);
    
    // Renderizar edificio
    renderBuilding(building);
    
    // Efecto de construcción
    showNotification(`✅ ${BUILDING_INFO[buildingType].name} construida!`, 'success');
    
    // Actualizar UI
    updateGameUI();
    drawMiniMap();
}

function renderBuilding(building) {
    const tile = document.querySelector(`.map-grid`);
    const tileSize = 40;
    
    const buildingEl = document.createElement('div');
    buildingEl.className = 'building-tile';
    // add type as class for custom styling (e.g. road)
    buildingEl.classList.add(building.type);
    buildingEl.textContent = BUILDING_INFO[building.type].icon;
    buildingEl.style.left = (building.x * tileSize) + 'px';
    buildingEl.style.top = (building.y * tileSize) + 'px';
    buildingEl.title = BUILDING_INFO[building.type].name;
    
    buildingEl.addEventListener('click', (e) => {
        e.stopPropagation();
        showBuildingInfo(building);
    });
    
    tile.appendChild(buildingEl);
}

function showBuildingInfo(building) {
    const info = BUILDING_INFO[building.type];
    document.getElementById('selectedBuilding').textContent = 
        `${info.icon} ${info.name} (Salud: ${building.health}/100)`;
}

function togglePause() {
    gameState.isPaused = !gameState.isPaused;
    const btn = document.getElementById('pauseBtn');
    btn.textContent = gameState.isPaused ? '▶️ Reanudar' : '⏸️ Pausa';
    btn.style.background = gameState.isPaused ? '#e74c3c' : '#3498db';
}

function changeGameSpeed() {
    const speeds = [0.5, 1, 2, 4];
    const currentIndex = speeds.indexOf(gameState.gameSpeed);
    gameState.gameSpeed = speeds[(currentIndex + 1) % speeds.length];
    
    document.getElementById('speedBtn').textContent = `⏩ ${gameState.gameSpeed}x`;
}

function openSettings() {
    document.getElementById('settingsModal').classList.add('show');
}

function closeSettings() {
    document.getElementById('settingsModal').classList.remove('show');
}

function updateGameUI() {
    // Actualizar recursos
    document.getElementById('gold').textContent = gameState.resources.gold;
    document.getElementById('wood').textContent = gameState.resources.wood;
    document.getElementById('stone').textContent = gameState.resources.stone;
    document.getElementById('food').textContent = gameState.resources.food;
    document.getElementById('water').textContent = gameState.resources.water;
    document.getElementById('electricity').textContent = 
        `${gameState.resources.electricity}/${gameState.maxElectricity}`;
    
    // Actualizar estadísticas
    document.getElementById('population').textContent = gameState.population.toLocaleString();
    document.getElementById('happiness').style.width = (gameState.happiness * 100) + '%';
    document.getElementById('pollution').style.width = (gameState.pollution * 100) + '%';
    document.getElementById('cityLevel').textContent = gameState.cityLevel;
    document.getElementById('prestige').textContent = gameState.prestige;
    
    // Actualizar tiempo
    document.getElementById('day').textContent = gameState.currentDay;
    document.getElementById('month').textContent = gameState.currentMonth;
    document.getElementById('year').textContent = gameState.currentYear;
}

function simulateGameTick() {
    if (gameState.isPaused) return;
    
    // Producción de recursos
    gameState.resources.gold += 10 * gameState.gameSpeed;
    gameState.resources.wood += 5 * gameState.gameSpeed;
    gameState.resources.stone += 3 * gameState.gameSpeed;
    gameState.resources.electricity = Math.min(
        gameState.resources.electricity + 2 * gameState.gameSpeed,
        gameState.maxElectricity
    );
    
    // Crecimiento de población
    gameState.population += Math.floor(gameState.population * 0.001);
    
    // Cambios en felicidad
    gameState.happiness = Math.max(0, gameState.happiness - 0.001);
    gameState.happiness = Math.min(1, gameState.happiness + (gameState.buildings.length * 0.0001));
    
    // Cambios en contaminación
    gameState.pollution += gameState.buildings.filter(b => b.type === 'factory').length * 0.0001;
    gameState.pollution = Math.max(0, gameState.pollution - 0.00002);
    
    // Avanzar tiempo
    gameState.currentDay++;
    if (gameState.currentDay > 30) {
        gameState.currentDay = 1;
        gameState.currentMonth++;
        showNotification('📆 Nuevo mes!', 'info');
    }
    if (gameState.currentMonth > 12) {
        gameState.currentMonth = 1;
        gameState.currentYear++;
        showNotification('🎉 ¡Nuevo año!', 'success');
    }
    
    // Si población es muy alta
    if (gameState.population > gameState.cityLevel * 10000) {
        gameState.cityLevel++;
        showNotification('⭐ ¡Tu ciudad subió de nivel!', 'success');
    }
    
    updateGameUI();
}

function drawMiniMap() {
    const canvas = document.getElementById('minimapCanvas');
    const ctx = canvas.getContext('2d');
    
    const tileWidth = canvas.width / GAME_CONFIG.gridWidth;
    const tileHeight = canvas.height / GAME_CONFIG.gridHeight;
    
    // Fondo
    ctx.fillStyle = '#87ceeb';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    
    // Dibujar edificios
    gameState.buildings.forEach(building => {
        ctx.fillStyle = getColorForBuilding(building.type);
        ctx.fillRect(
            building.x * tileWidth,
            building.y * tileHeight,
            tileWidth,
            tileHeight
        );
    });
}

function getColorForBuilding(type) {
    const colors = {
        residence: '#ff9999',
        factory: '#999999',
        park: '#99ff99',
        power: '#ffff99',
        hospital: '#ff99ff',
        school: '#99ffff',
        road: '#cccccc',
        tree: '#33aa33',
        rock: '#666666'
    };
    return colors[type] || '#ffffff';
}

function showNotification(message, type = 'info') {
    const newsList = document.querySelector('.news-list');
    const newsItem = document.createElement('div');
    newsItem.className = `news-item ${type}`;
    newsItem.textContent = message;
    
    newsList.insertBefore(newsItem, newsList.firstChild);
    
    // Limitar el número de notificaciones
    while (newsList.children.length > 5) {
        newsList.removeChild(newsList.lastChild);
    }
    
    // Auto-remover después de 5 segundos
    setTimeout(() => {
        if (newsItem.parentNode) {
            newsItem.remove();
        }
    }, 5000);
}

function startGameLoop() {
    // Simular cada segundo
    setInterval(() => {
        simulateGameTick();
    }, 1000 / gameState.gameSpeed);
}
