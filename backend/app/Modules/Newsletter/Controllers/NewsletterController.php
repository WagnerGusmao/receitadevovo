<?php

namespace App\Modules\Newsletter\Controllers;

use App\Core\Controllers\Controller;
use App\Modules\Newsletter\Models\NewsletterSubscriber;
use App\Modules\Newsletter\Mail\NewsletterMail;
use Illuminate\Support\Facades\Mail;
use Illuminate\Http\Request;

class NewsletterController extends Controller
{
    /**
     * Subscribe a new email to the newsletter.
     */
    public function subscribe(Request $request)
    {
        $request->validate([
            'email' => 'required|email|max:255',
        ]);

        $email = strtolower(trim($request->email));

        $subscriber = NewsletterSubscriber::where('email', $email)->first();

        if ($subscriber) {
            if ($subscriber->active) {
                return $this->success(
                    $subscriber,
                    'Você já está inscrito em nossa newsletter!'
                );
            }

            $subscriber->active = true;
            $subscriber->save();

            return $this->success(
                $subscriber,
                'Inscrição reativada com sucesso! Bem-vindo(a) de volta.'
            );
        }

        $subscriber = NewsletterSubscriber::create([
            'email' => $email,
            'active' => true,
        ]);

        return $this->success(
            $subscriber,
            'Inscrição realizada com sucesso! Bem-vindo(a) à nossa newsletter.',
            201
        );
    }

    /**
     * List subscribers for admin.
     */
    public function adminIndex(Request $request)
    {
        $query = NewsletterSubscriber::orderBy('created_at', 'desc');

        if ($request->has('search') && !empty($request->search)) {
            $query->where('email', 'like', '%' . $request->search . '%');
        }

        if ($request->has('active') && $request->active !== null && $request->active !== '') {
            $active = filter_var($request->active, FILTER_VALIDATE_BOOLEAN);
            $query->where('active', $active);
        }

        $subscribers = $query->get();

        return $this->success($subscribers);
    }

    /**
     * Toggle subscriber active status.
     */
    public function adminToggle($id)
    {
        $subscriber = NewsletterSubscriber::findOrFail($id);
        $subscriber->active = !$subscriber->active;
        $subscriber->save();

        $status = $subscriber->active ? 'ativada' : 'desativada';

        return $this->success(
            $subscriber,
            "Inscrição de {$subscriber->email} foi {$status} com sucesso."
        );
    }

    /**
     * Delete a subscriber.
     */
    public function adminDestroy($id)
    {
        $subscriber = NewsletterSubscriber::findOrFail($id);
        $email = $subscriber->email;
        $subscriber->delete();

        return $this->success(
            [],
            "Inscrição de {$email} foi removida com sucesso."
        );
    }

    /**
     * Send newsletter email to all active subscribers.
     */
    public function send(Request $request)
    {
        $request->validate([
            'subject' => 'required|string|max:255',
            'body' => 'required|string',
        ]);

        $subscribers = NewsletterSubscriber::where('active', true)->get();

        if ($subscribers->isEmpty()) {
            return $this->error('Não há inscritos ativos para receber a newsletter.');
        }

        foreach ($subscribers as $subscriber) {
            Mail::to($subscriber->email)
                ->send(new NewsletterMail($request->subject, $request->body));
        }

        return $this->success(
            ['count' => $subscribers->count()],
            "Newsletter enviada com sucesso para {$subscribers->count()} inscrito(s)."
        );
    }
}
