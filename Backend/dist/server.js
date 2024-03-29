"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importStar(require("express"));
const UserRoute_1 = __importDefault(require("./route/UserRoute"));
const AdminRoute_1 = __importDefault(require("./route/AdminRoute"));
const cors_1 = __importDefault(require("cors"));
const https_1 = __importDefault(require("https"));
class Server {
    constructor() {
        this.config = () => {
            this.backend.set('port', 80);
            this.backend.use((0, express_1.urlencoded)({ extended: true }));
            this.backend.use((0, express_1.json)());
            this.backend.use((0, cors_1.default)());
        };
        this.route = () => {
            this.backend.use('/api', this.userRoute.router);
            this.backend.use('/api/admin', this.adminRoute.router);
        };
        this.start = () => {
            this.backend.listen(this.backend.get('port'), () => {
                console.log('Server on port:', this.backend.get('port'));
            });
        };
        this.https = https_1.default;
        this.backend = (0, express_1.default)();
        this.userRoute = new UserRoute_1.default();
        this.adminRoute = new AdminRoute_1.default();
        this.config();
        this.route();
        this.start();
    }
}
const server = new Server();
