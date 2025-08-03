import { Injectable } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { ChatMessage } from '../models/chat-message.model';


@Injectable({
  providedIn: 'root'
})
export class ChatService {
  private ws!: WebSocket;
  private messageSubject = new Subject<ChatMessage>();

  constructor() {
    this.connect();
  }

  private connect(): void {
    this.ws = new WebSocket('ws://localhost:8080/ws/chat');

    this.ws.onmessage = (event) => {
      const message = JSON.parse(event.data);
      this.messageSubject.next(message);
    };

    this.ws.onerror = (error) => {
      console.error('WebSocket error:', error);
    };

    this.ws.onclose = () => {
      console.warn('WebSocket connection closed. Attempting reconnect...');
      setTimeout(() => this.connect(), 2000);
    };
  }

  onMessage(): Observable<ChatMessage> {
    return this.messageSubject.asObservable();
  }

  send(msg: ChatMessage): void {
    if (this.ws.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify(msg));
    } else {
      console.warn('WebSocket not connected. Message not sent.');
    }
  }
}
