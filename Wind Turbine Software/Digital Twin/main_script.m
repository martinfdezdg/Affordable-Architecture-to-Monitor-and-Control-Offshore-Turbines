clear;

% GEMELO DIGITAL

% ThingSpeak - Estado del simulador
simulatorStatusChannelID = 1662512;
simulatorStatusWriteKey = 'P4H6GIQKLNK3QQH6';
simulatorStatusReadKey = 'G10EN02P62RRG5G4';

% ThingSpeak - Estabilidad del simulador
simulatorStabilityChannelID = 1700200;
simulatorStabilityWriteKey = 'SYJ6VDLQSSQV6K79';
simulatorStabilityReadKey = '5IN2NXOZT33ANQQP';

% ThingSpeak - Comandos del simulador
simulatorCommandChannelID = 1664848;
simulatorCommandWriteKey = 'UO7AMO2P2ZXN99L7';
simulatorCommandReadKey = 'CR8M6SL5COQ69DCL';

% ThingSpeak - Estado del prototipo
prototipeStatusChannelID = 1694179;
prototipeStatusWriteKey = '4LMAXES0BC3077IF';
prototipeStatusReadKey = 'C1U3DAHYYMMGP9CQ';

% ThingSpeak - Estabilidad del prototipo
prototipeStabilityTwinChannelID = 1710531;
prototipeStabilityWriteKey = '0QD6M7UATQLSUY8J';
prototipeStabilityReadKey = 'WW8WO3GAC662P4Q6';

% ThingSpeak - Comandos del prototipo
prototipeCommandChannelID = 1695953;
prototipeCommandWriteKey = '478K511ZLZ4HI276';
prototipeCommandReadKey = 'T21L0ZFM18CZR710';

% Crea un modelo de la turbina
turbine1 = ModelSimulator(simulatorStatusChannelID, simulatorStatusWriteKey, simulatorStatusReadKey, ...
    simulatorStabilityChannelID, simulatorStabilityWriteKey, simulatorStabilityReadKey, ...
    simulatorCommandChannelID, simulatorCommandWriteKey, simulatorCommandReadKey);
% Crea un modelo de la turbina
turbine2 = ModelPrototype(prototipeStatusChannelID, prototipeStatusWriteKey, prototipeStatusReadKey, ...
    prototipeStabilityTwinChannelID, prototipeStabilityWriteKey, prototipeStabilityReadKey, ...
    prototipeCommandChannelID, prototipeCommandWriteKey, prototipeCommandReadKey);

% Crea un modelo de la granja de turbinas
farm = ModelFarm([turbine1,turbine2]);

% Inicia la vista asociada a ese modelo
view = ViewFarm(farm);