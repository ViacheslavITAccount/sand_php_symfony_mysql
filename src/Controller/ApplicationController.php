<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;

class ApplicationController extends AbstractController
{
    public function index(): JsonResponse
    {
        return new JsonResponse(['OK']);
    }
}