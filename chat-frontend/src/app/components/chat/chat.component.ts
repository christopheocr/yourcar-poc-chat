import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ChatMessage } from '../../models/chat-message.model';
import { ChatService } from '../../services/chat.service';


@Component({
  selector: 'app-chat',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './chat.component.html',
  styleUrls: ['./chat.component.scss']
})
export class ChatComponent {
  username = '';
  role = 'client';
  messageContent = '';
  messages: ChatMessage[] = [];
  connected = false;

  constructor(private chatService: ChatService) {}

  ngOnInit(): void {
    this.chatService.onMessage().subscribe((msg: ChatMessage) => {
      this.messages.push(msg);
    });
  }

  connect(): void {
    if (this.username.trim()) {
      this.connected = true;
    }
  }

  sendMessage(): void {
    if (this.messageContent.trim()) {
      const msg: ChatMessage = {
        sender: `${this.username} (${this.role})`,
        content: this.messageContent,
        timestamp: new Date().toISOString()
      };
      this.chatService.send(msg);
      this.messageContent = '';
    }
  }
}
