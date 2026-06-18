<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class PasswordResetMail extends Mailable
{
    use Queueable, SerializesModels;

    public $code;

    /**
     * Create a new message instance.
     */
    public function __construct($code)
    {
        $this->code = $code;
    }

    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Recuperação de Senha - Receita de Vovó',
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        return new Content(
            htmlString: "
                <div style='font-family: sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e4e4e7; border-radius: 8px;'>
                    <h2 style='color: #4F6F52; text-align: center;'>Recuperação de Senha</h2>
                    <p>Olá,</p>
                    <p>Recebemos uma solicitação para redefinir a senha da sua conta no <strong>Receita de Vovó</strong>.</p>
                    <p>Use o código de verificação abaixo para continuar com o processo:</p>
                    <div style='background-color: #f4f4f5; padding: 15px; text-align: center; border-radius: 8px; margin: 20px 0;'>
                        <span style='font-size: 28px; font-weight: bold; letter-spacing: 4px; color: #4F6F52;'>{$this->code}</span>
                    </div>
                    <p style='color: #71717a; font-size: 14px;'>Este código é válido por 15 minutos. Se você não solicitou esta redefinição, por favor desconsidere este e-mail.</p>
                </div>
            ",
        );
    }
}
