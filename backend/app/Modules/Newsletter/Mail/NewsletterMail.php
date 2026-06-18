<?php

namespace App\Modules\Newsletter\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class NewsletterMail extends Mailable
{
    use Queueable, SerializesModels;

    public $subjectLine;
    public $bodyContent;

    /**
     * Create a new message instance.
     */
    public function __construct(string $subjectLine, string $bodyContent)
    {
        $this->subjectLine = $subjectLine;
        $this->bodyContent = $bodyContent;
    }

    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        return new Envelope(
            subject: $this->subjectLine,
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        $styledBody = "
            <div style='font-family: sans-serif; max-width: 600px; margin: 0 auto; padding: 25px; border: 1px solid #e4e4e7; border-radius: 12px; background-color: #FAF6F0;'>
                <div style='text-align: center; margin-bottom: 25px; border-bottom: 2px solid #EAE3D2; padding-bottom: 20px;'>
                    <h1 style='color: #4F6F52; margin: 0; font-size: 26px; font-family: Georgia, serif;'>🌿 Receita de Vovó</h1>
                    <p style='color: #8C6A5C; margin: 6px 0 0 0; font-size: 14px; font-style: italic;'>Ritual & Bem-Estar Ancestral</p>
                </div>
                <div style='color: #2D2727; font-size: 16px; line-height: 1.6; min-height: 180px;'>
                    {$this->bodyContent}
                </div>
                <div style='text-align: center; margin-top: 35px; border-top: 1px solid #EAE3D2; padding-top: 20px; color: #7F8487; font-size: 12px; line-height: 1.5;'>
                    <p style='margin: 0 0 5px 0;'>Você recebeu esta mensagem porque se inscreveu na nossa newsletter.</p>
                    <p style='margin: 0;'>Receita de Vovó - Barueri, São Paulo - Brasil</p>
                </div>
            </div>
        ";

        return new Content(
            htmlString: $styledBody,
        );
    }
}
